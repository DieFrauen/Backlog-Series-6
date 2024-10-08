--Crest of the Blazon
function c26062012.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	e0:SetCondition(c26062012.actcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26062012,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,26062012)
	e2:SetCost(c26062012.cost)
	e2:SetTarget(c26062012.tgtg)
	e2:SetOperation(c26062012.tgop)
	c:RegisterEffect(e2)
	--retrieve
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26062012,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e3:SetCountLimit(1,{26062012,1})
	e3:SetTarget(c26062012.thtg)
	e3:SetOperation(c26062012.thop)
	c:RegisterEffect(e3)
	--Normal Summon a FIRE Monster of a given level
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(26062012,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e4:SetCountLimit(1,{26062012,2})
	e4:SetTarget(c26062012.tftg)
	e4:SetOperation(c26062012.tfop)
	c:RegisterEffect(e4)
	if not c26062012.global_check then
		c26062012.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c26062012.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetLabelObject(ge1)
		ge2:SetOperation(c26062012.clearop)
		Duel.RegisterEffect(ge2,0)
	end
	--Negate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetOperation(c26062012.disop)
	c:RegisterEffect(e5)
	aux.DoubleSnareValidity(c,LOCATION_SZONE)
end
function c26062012.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=3
end
function c26062012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(26062012)==0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:RegisterFlagEffect(26062012,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c26062012.thfilter(c,lv)
	return c:IsLevelBelow(lv) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function c26062012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=Duel.GetCurrentChain()
	if chk==0 then return Duel.IsExistingMatchingCard(c26062012.thfilter,tp,LOCATION_DECK,0,1,nil,lv) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c26062012.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetCurrentChain()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26062012.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26062012.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x662) and c:IsAbleToGrave()
end
function c26062012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lv=Duel.GetCurrentChain()
	local gg=Duel.GetMatchingGroup(c26062012.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return gg:CheckWithSumEqual(Card.GetLevel,lv,1,99,c) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end
function c26062012.tgop(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetCurrentChain()
	local mg=Duel.GetMatchingGroup(c26062012.tgfilter,tp,LOCATION_DECK,0,nil,lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=mg:SelectWithSumEqual(tp,Card.GetLevel,lv,1,99,tc)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function c26062012.nsfilter(c,lv)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_PYRO)
end
function c26062012.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=Duel.GetCurrentChain()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26062012.nsfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,lv) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26062012.tfop(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetCurrentChain()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26062012.nsfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,lv)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c26062012.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain()
	if ch<=2 then return end
	local e1,p1=Duel.GetChainInfo(ch  ,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local e2,p2=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local e3,p3=Duel.GetChainInfo(ch-2,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if e2 and e3
	and e1:GetHandler():IsSetCard(0x662) and e3:GetHandler():IsSetCard(0x662)
	and p1==p3 and p1~=p2 then
		local ec=e2:GetHandler()
		ec:RegisterFlagEffect(26062012,RESET_CHAIN,0,1)
	end
end
function c26062012.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ep==tp or rc:GetFlagEffect(26062012)==0 then return end
	Duel.Hint(HINT_CARD,ep,26062012)
	Duel.NegateEffect(ev)
end