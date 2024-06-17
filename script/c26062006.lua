--Blazon - Vair the Vanguard
function c26062006.initial_effect(c)
	c:SetSPSummonOnce(26062006)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26062006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26062006.spcon)
	e1:SetTarget(c26062006.sptg)
	e1:SetOperation(c26062006.spop)
	c:RegisterEffect(e1)
	--cannot link material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	--grave eff
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26062006,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,{26062006,1})
	e4:SetTarget(c26062006.grtg)
	e4:SetOperation(c26062006.grop)
	c:RegisterEffect(e4)
end
function c26062006.cfilter(c,e,tp)
	return c:IsSetCard(0x662) and c:IsMonster() and not c:IsCode(id) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26062006.filter(c,e,tp,tid)
	return c:GetTurnID()==tid and c:IsSetCard(0x662) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26062006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26062006.cfilter,1,nil,e,tp)
end
function c26062006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c26062006.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tid) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c26062006.spop(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26062006.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp,tid)
	if #g>0 then
		g:AddCard(e:GetHandler())
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26062006.grtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26062006.grfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26062006.grfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26062006.grfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26062006.grop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local b1= tc:IsLevelAbove(2)
		local b2= tc:GetType()&TYPE_TUNER ==0
		local b3= (b1 and b2)
		if not (b1 or b2) then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26062006,1))
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(26062006,2)},
			{b2,aux.Stringid(26062006,3)},
			{b3,aux.Stringid(26062006,4)})
		if op~=2 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
		end
		if op~=1 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_TUNER)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
		end
	end
end
function c26062006.lvfilter(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(1) and not c:GetLevel()~=ch
end
function c26062006.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	e:SetLabel(Duel.GetCurrentChain())
	local lv=e:GetLabel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26062006.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26062006.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26062006.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26062006.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end