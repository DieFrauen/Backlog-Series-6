--Entrophys Regulator of Gaseous
function c26065010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--transform traps
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c26065010.limit)
	e2:SetValue(0x665)
	c:RegisterEffect(e2)
	--grant normal summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26065010,0))
	e3:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e3:SetCountLimit(1,26065010)
	e3:SetTarget(c26065010.gtg)
	e3:SetOperation(c26065010.gop)
	c:RegisterEffect(e3)
	--Activate from hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c26065010.handcon)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(26065010,ACTIVITY_CHAIN,c26065010.chainfilter)
	--activate traps from Hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,26065010)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x665))
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e6)
end
function c26065010.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c26065010.limit(e,c)
	return c:IsType(TYPE_TRAP)
end
function c26065010.filter(c,e)
	return c:IsSetCard(0x665) and c:IsSummonable(true,nil,e)
end
function c26065010.exfilter(c,e)
	return c:IsSetCard(0x665) and c:IsLinkSummonable(nil)
end
function c26065010.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		  Duel.IsExistingMatchingCard(c26065010.filter,tp,LOCATION_HAND,0,1,nil,e)
	local s2=Duel.IsExistingMatchingCard(c26065010.exfilter,tp,LOCATION_EXTRA,0,1,nil)
	if chk==0 then return s1 or s2 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c26065010.gop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g1=Duel.GetMatchingGroup(c26065010.filter  ,tp,LOCATION_HAND,0,nil,e)
	local g2=Duel.GetMatchingGroup(c26065010.exfilter,tp,LOCATION_EXTRA,0,nil,e)
	g1:Merge(g2)
	tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc then
		if tc:IsLinkSummonable() then
			Duel.LinkSummon(tp,tc)
		elseif tc:IsSummonable(true,nil) then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
function c26065010.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCustomActivityCount(26065010,1-tp,ACTIVITY_CHAIN)>0
end