--Crystelloy Splicing
function c26063012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26063012.target)
	e1:SetOperation(c26063012.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e2:SetDescription(aux.Stringid(26063010,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c26063012.tdcost)
	e2:SetTarget(c26063012.sptg)
	e2:SetOperation(c26063012.spop)
	c:RegisterEffect(e2)
	--act hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c26063012.hcond)
	c:RegisterEffect(e3)
	--count
	aux.GlobalCheck(c26063012,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c26063012.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		ge2:SetOperation(c26063012.checkop2)
		Duel.RegisterEffect(ge2,0)
	end)
end
function c26063012.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),26063012,RESET_PHASE+PHASE_END,0,1)
	end
end
function c26063012.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),26063013,RESET_PHASE+PHASE_END,0,1)
	end
end
function c26063012.filter(c,e,tp,tc)
	return c:IsSetCard(0x663) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26063012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sum1=Duel.GetFlagEffect(1-tp,26063012)
	local sum2=Duel.GetFlagEffect(1-tp,26063013)
	local sum=sum1-sum2
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26063012.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and sum>=1
		and Duel.IsExistingMatchingCard(c26063012.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c26063012.activate(e,tp,eg,ep,ev,re,r,rp)
	local sum1,sum2=Duel.GetFlagEffect(1-tp,26063012),Duel.GetFlagEffect(1-tp,26063013)
	local sum=sum1-sum2
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if sum>ft then sum=ft end
	local g=Duel.GetMatchingGroup(c26063012.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,tc)
	if sum>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then sum=1 end
	if sum>=1 and #g>=1 then
		local mg=g:Select(tp,1,sum,nil)
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26063012,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst())
		end
	end
end

function c26063012.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,1,REASON_COST)
end
function c26063012.refilter(c,e,tp,tid)
	return c:IsType(TYPE_XYZ) and c:GetRank()==4
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26063012.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26063012.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26063012.refilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c26063012.refilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26063012.spop(e,tp,eg,ep,ev,re,r,rp)
	local sum1,sum2=Duel.GetFlagEffect(1-tp,26063012),Duel.GetFlagEffect(1-tp,26063013)
	local sum=sum1-sum2
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
	and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0
	and sum>0
	and Duel.SelectYesNo(tp,aux.Stringid(26063012,3)) then
		local mg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,sum,nil,0x663)
		Duel.Overlay(tc,mg)
		if tc:IsType(TYPE_GEMINI) then
			Duel.Hint(HINT_CARD,tp,tc:GetCode())
			tc:EnableGeminiState()
		end
	end
end
function c26063012.hcond(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local sum1,sum2=Duel.GetFlagEffect(1-tp,26063012),Duel.GetFlagEffect(1-tp,26063013)
	local sum=sum1-sum2
	return sum>=4
end