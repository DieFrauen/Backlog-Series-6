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
	--synchro summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26062007,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetLabel(3)
	e5:SetHintTiming(TIMING_BATTLE_STEP_END+TIMING_BATTLE_END)
	e5:SetCondition(c26062007.spcon)
	e5:SetTarget(c26062007.sctg)
	e5:SetOperation(c26062007.scop)
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
	e1:SetTarget(function(_,c) return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e1,tp)
	--Clock Lizard check
	--aux.addTempLizardCheck(c,tp,function(_,c) return not c:IsOriginalType(TYPE_SYNCHRO) end)
end
function c26062007.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x662)
end
function c26062007.ssfilter(c,sc,mg)
	return c:IsSynchroSummonable(sc,mg) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c26062007.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local mg=Duel.GetMatchingGroup(c26062007.mfilter,tp,LOCATION_MZONE,0,nil)
		return not c:IsStatus(STATUS_CHAINING)
			and Duel.IsExistingMatchingCard(c26062007.ssfilter,tp,LOCATION_EXTRA,0,1,nil,c,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26062007.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ch=Duel.GetCurrentChain()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(c26062007.mfilter,tp,LOCATION_MZONE,0,nil,ch)
	local g=Duel.GetMatchingGroup(c26062007.ssfilter,tp,LOCATION_EXTRA,0,nil,c,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c,mg)
	end
end