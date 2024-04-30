--Over-wind Astrolabe
function c26064006.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,extrafil=c26064006.extrafil,extraop=c26064006.extraop,matfilter=c26064006.forcedgroup,sumpos=POS_FACEUP+POS_FACEDOWN_DEFENSE,stage2=c26064006.stage2})
	e1:SetCategory(e1:GetCategory()|CATEGORY_POSITION)
	c:RegisterEffect(e1)
	--DRAW effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetCost(c26064006.spcost)
	e2:SetTarget(c26064006.drtg)
	e2:SetOperation(c26064006.drop)
	c:RegisterEffect(e2)
end
c26064006.listed_names={26064004}
c26064006.DRAW=true
c26064006.ACTV=true
function c26064006.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
end
function c26064006.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	return Duel.ChangePosition(mat,POS_FACEDOWN_DEFENSE)
end
function c26064006.forcedgroup(c,e,tp)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsImmuneToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0
end
function c26064006.flipop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=Duel.GetMatchingGroup(c26064006.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c26064006.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			tc:SetMaterial(mat)
			Duel.ChangePosition(mat,POS_FACEDOWN_DEFENSE)
			Duel.BreakEffect()
			local pos=Duel.SelectPosition(tp,tc,POS_FACEUP+POS_FACEDOWN_DEFENSE)
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,pos)
			if pos==POS_FACEDOWN_DEFENSE then
				Duel.ConfirmCards(1-tp,tc)
				local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
				Duel.ShuffleSetCard(sg)
			end
			tc:CompleteProcedure()
		end
	end
end
function c26064006.stage2(mg,e,tp,eg,ep,ev,re,r,rp,sc)
	if sc:IsFacedown() then
		local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
		Duel.ShuffleSetCard(sg)
	end
end
function c26064006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064006.spfilter(c,e,tp)
	return (c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or 
		   (c:IsCode(26064004) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true))
end
function c26064006.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c26064006.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26064006.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c26064006.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26064006.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp):GetFirst()
	if tc then
		local pos=Duel.SelectPosition(tp,tc,POS_DEFENSE)
		if tc:IsCode(26064004) then
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,pos)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,pos)
		end
		c26064006.stage2(nil,e,tp,eg,ep,ev,re,r,rp,tc)
	end
end