--Desceptim Pseudomonarkia
function c26067012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(26067012,0))
	c:RegisterEffect(e1)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c26067012.condition)
	c:RegisterEffect(e0)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(26067012,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,26067012)
	e2:SetCost(c26067012.tdcost)
	e2:SetTarget(c26067012.tdtg)
	e2:SetOperation(c26067012.tdop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26067012,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,26067012)
	e3:SetTarget(c26067012.thtg)
	e3:SetOperation(c26067012.thop)
	c:RegisterEffect(e3)
	--psummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(26067012,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,26067012)
	e4:SetCost(c26067012.spcost)
	e4:SetCondition(c26067012.spcon)
	e4:SetTarget(c26067012.sptg)
	e4:SetOperation(c26067012.spop)
	c:RegisterEffect(e4)
	aux.GlobalCheck(c26067012,function()
		c26067012.should_check=false
		c26067012.exclude_card=nil
		local geff=Effect.CreateEffect(c)
		geff:SetType(EFFECT_TYPE_FIELD)
		geff:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		geff:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		geff:SetTargetRange(1,1)
		geff:SetTarget(function(e,c)
			if c26067012.should_check or c26067012.exclude_card then
				return c==c26067012.exclude_card or not c:IsType(TYPE_PENDULUM)
			end
			return false
		end)
		Duel.RegisterEffect(geff,0)
	end)
	Duel.AddCustomActivityCounter(26067012,ACTIVITY_SPSUMMON,c26067012.counterfilter)
end
function c26067012.counterfilter(c)
	return c:IsSetCard(0x667)
end
function c26067012.condition(e)
	local tp=e:GetHandlerPlayer()
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not tc1 or not tc2 then return false end
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	if scl1>scl2 then scl1,scl2=scl2,scl1 end
	return scl1==6 and scl2==8
end
function c26067012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(26067012,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c26067012.splimit)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(26061012,3),nil)
	e:SetLabel(100)
	return true
end
function c26067012.splimit(e,c)
	return not c:IsSetCard(0x667) or not c:IsLocation(LOCATION_EXTRA)
end
function c26067012.spcon(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or c==rpz then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(c26067012.penfilter,1,nil,e,tp,lscale,rscale)
end
function c26067012.penfilter(c,e,tp,lscale,rscale)
	return c:IsSetCard(0x667) and Pendulum.Filter(c,e,tp,lscale,rscale)
end
function c26067012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==100 then return true end
		c26067012.should_check=true
		local res=Duel.IsPlayerCanPendulumSummon(tp)
		c26067012.should_check=nil
		return res
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function c26067012.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.PendulumSummon(tp)
	end
end
function c26067012.tdfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and c:IsAbleToDeck()
end
function c26067012.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function c26067012.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067012.tdfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067012.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26067012.defilter,tp,LOCATION_HAND,0,1,nil)
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if sc and Duel.SendtoDeck(sc,1-tp,0,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_DECK) then
		sc:ReverseInDeck()
		sc:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD&~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
	end
end
function c26067012.thfilter(c,p)
	return c:IsFaceup() and c:IsSetCard(0x667) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:GetOwner()==p
end
function c26067012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067012.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,LOCATION_EXTRA+LOCATION_GRAVE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c26067012.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26067012.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,LOCATION_EXTRA+LOCATION_GRAVE,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end