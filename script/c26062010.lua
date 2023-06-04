--Blazon Field of Command
function c26062010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(26062010,0))
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26062010,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetLabel(0)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c26062010.damtg)
	e2:SetOperation(c26062010.damop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26062010,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,26062010)
	e3:SetCondition(c26062010.drcon)
	e3:SetTarget(c26062010.drtg)
	e3:SetOperation(c26062010.drop)
	c:RegisterEffect(e3)
	if not c26062010.global_check then
		c26062010.global_check=true
		c26062010[0]=0
		c26062010[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c26062010.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c26062010.clearop)
		Duel.RegisterEffect(ge2,0)
	end
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x662))
	c:RegisterEffect(e4)
	--damage on chain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c26062010.regop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c26062010.chcon)
	e6:SetOperation(c26062010.chop)
	c:RegisterEffect(e6)
end
function c26062010.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(26062010,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c26062010.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and c:GetFlagEffect(26062010)>0
end
function c26062010.chop(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain()
	local lg=Group.CreateGroup()
	for i=1,ch do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp==tp and tc:IsSetCard(0x662) and tc:IsLevelAbove(1) then
			lg:AddCard(tc)
		end
	end
	local val=lg:GetSum(Card.GetOriginalLevel)
	if val<=0 then return end
	Duel.Hint(HINT_CARD,0,26062010)
	Duel.Damage(1-tp,val*100,REASON_EFFECT)
end
function c26062010.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c26062010.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c26062010.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local rn=Duel.GetCurrentChain()
	if c26062010[rp]<rn then
		c26062010[rp]=rn
	end
end
function c26062010.clearop(e,tp,eg,ep,ev,re,r,rp)
	c26062010[0]=0
	c26062010[1]=0
end
function c26062010.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c26062010[tp]>0 and Duel.GetTurnPlayer()==tp
end
function c26062010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c26062010[tp]) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c26062010[tp])
end
function c26062010.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Draw(tp,c26062010[tp],REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,c)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,ct,ct,c)
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
end