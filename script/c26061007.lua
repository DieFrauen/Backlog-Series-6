--Fulmiknight Celestial Vault
function c26061007.initial_effect(c)
	c:EnableCounterPermit(0x5)
	c:SetCounterLimit(0x5,5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26061007.target)
	e1:SetOperation(c26061007.activate)
	c:RegisterEffect(e1)
	--leave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c26061007.leaveop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetLabelObject(e2)
	e3:SetOperation(c26061007.leave)
	c:RegisterEffect(e3)
	--lp loss
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PAY_LPCOST)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c26061007.recon)
	e4:SetOperation(c26061007.reop)
	c:RegisterEffect(e4)
	local e4b=e4:Clone()
	e4b:SetCode(EVENT_DAMAGE)
	c:RegisterEffect(e4b)
	--recover LIGHT Monsters
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26061007,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c26061007.thtg)
	e5:SetOperation(c26061007.thop)
	c:RegisterEffect(e5)
	--Activate "Fulmiknight Siege"
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26061007,2))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCost(c26061007.tfcost)
	e6:SetTarget(c26061007.tftg)
	e6:SetOperation(c26061007.tfop)
	c:RegisterEffect(e6)
	
	aux.GlobalCheck(c26061007,function()
		c26061007[0]=nil
		c26061007[1]=nil
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(c26061007.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c26061007.clearop)
		Duel.RegisterEffect(ge2,0)
	end)
	--Prevent negation
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_INACTIVATE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,1)
	e6:SetValue(c26061007.efilter)
	c:RegisterEffect(e6)
end
function c26061007.filter(c)
	return c:IsSetCard(0x661) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c26061007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26061007.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26061007.rescon1(sg,e,tp,mg)
	return #sg:Filter(Card.IsLocation,nil,LOCATION_DECK)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
end
function c26061007.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c26061007.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	local tg=aux.SelectUnselectGroup(g,e,tp,1,2,c26061007.rescon1,1,tp,HINTMSG_TOGRAVE,c26061007.rescon1)
	if #tg>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
		local lpv=tg:GetSum(Card.GetBaseAttack)+tg:GetSum(Card.GetBaseDefense)
		Duel.Recover(tp,lpv,REASON_EFFECT)
	end
end
function c26061007.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x5)
	if ct then
		e:SetLabel(ct)
	else e:SetLabel(0) end
end
function c26061007.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	if ct and c:IsPreviousControler(tp) then
		Duel.Damage(tp,ct*2000,REASON_EFFECT)
	end
end
function c26061007.recon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep==tp and Duel.GetLP(tp)>0 or Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_LOSE_LP)
end
function c26061007.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tabv,v=1000,0
	while c:IsCanAddCounter(0x5,v+1,REASON_EFFECT) and ev>=tabv do
		tabv=tabv+1000
		v=v+1
	end
	if v==0 then return end
	local cv=c:GetCounter(0x5)
	c:AddCounter(0x5,v,REASON_EFFECT)
	local cv=c:GetCounter(0x5)-cv
	Duel.Recover(tp,cv*1000,REASON_EFFECT)
end
function c26061007.thfilter(c,tp)
	return c:IsSetCard(0x661) and c:IsMonster() and c:IsAbleToHand() and Duel.CheckLPCost(tp,c:GetBaseAttack()+c:GetBaseDefense())
end
function c26061007.rescon()
	return function (sg,e,tp,mg)
		local atk=sg:GetSum(Card.GetAttack)
		local def=sg:GetSum(Card.GetDefense)
		return atk+def==5000
	end
end 
function c26061007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c26061007.thfilter() end
	local g=Duel.GetMatchingGroup(c26061007.thfilter,tp,LOCATION_GRAVE,0,nil,tp,lp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),3,0,0)
end
function c26061007.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26061007.thfilter),tp,LOCATION_GRAVE,0,nil,tp)
	local sc=g:Select(tp,1,1,nil):GetFirst()
	if sc then
		Duel.PayLPCost(tp,sc:GetBaseAttack()+sc:GetBaseDefense())
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	end
end

function c26061007.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x5,5,REASON_COST) end
	c:RemoveCounter(tp,0x5,5,REASON_COST)
end
function c26061007.tffilter(c,tp)
	return c:IsCode(26061008) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26061007.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26061007.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c26061007.tfop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c26061007.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	local tc=0
	if #tg==tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK) then
		tc=tg:GetFirst()
	else
		tc=tg:Select(tp,1,1,nil):GetFirst()
	end
	Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
end

function c26061007.checkop(e,tp,eg,ep,ev,re,r,rp)
	c26061007[ep]=c26061007[ep]+ev
end
function c26061007.clearop(e,tp,eg,ep,ev,re,r,rp)
	c26061007[0]=0
	c26061007[1]=0
end
function c26061007.efilter(e,ct)
	local tp,te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return c26061007[tp]>c26061007[1-tp]
end