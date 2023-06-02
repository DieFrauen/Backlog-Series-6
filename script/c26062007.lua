--Blazon - Ermine the Insignia
function c26062007.initial_effect(c)
	c:SetSPSummonOnce(26062007)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26062007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(3)
	e1:SetCondition(c26062007.spcon)
	e1:SetTarget(c26062007.sptg)
	e1:SetOperation(c26062007.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetLabel(3)
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--cannot link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	--summon eff
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26062007,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetTarget(c26062007.target)
	e5:SetOperation(c26062007.operation)
	c:RegisterEffect(e5)
end
function c26062007.spcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp==tp and te:GetHandler():IsSetCard(0x662) then
			return Duel.GetCurrentChain()>=e:GetLabel()
		end
	end
end
function c26062007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not e:GetHandler():IsStatus(STATUS_CHAINING) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26062007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	--Cannot Special Summon from the Extra Deck, except Xyz Monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26062007,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(_,c) return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Clock Lizard check
	aux.addTempLizardCheck(c,tp,function(_,c) return not c:IsOriginalType(TYPE_XYZ) end)
end
function c26062007.filter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0x662) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c26062007.filter2,tp,0,LOCATION_MZONE,1,nil,e,tp,lv) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c26062007.filter2(c,e,tp,lv)
	return c:GetLevel()>=lv
end
function c26062007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c26062007.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26062007.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26062007.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end