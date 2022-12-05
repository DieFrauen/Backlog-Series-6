--The Desceptim Marshal - Bael
function c26067107.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--destroy and create pendulum scales
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26067107.detg)
	e1:SetOperation(c26067107.deop)
	c:RegisterEffect(e1)
end

function c26067107.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c26067107.pcfilter(c)
	return c:IsSetCard(0x667) and c:GetType()&TYPE_EFFECT|TYPE_PENDULUM ==TYPE_EFFECT|TYPE_PENDULUM and c:IsFaceup() and not c:IsForbidden()
end
function c26067107.mfilter(c,e)
	return c:IsMonster() and c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c26067107.fusion(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:CheckFusionMaterial(m) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function c26067107.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local pg=Duel.GetMatchingGroup(c26067107.pcfilter,tp,LOCATION_EXTRA,0,nil)
	local mg=Duel.GetMatchingGroup(c26067107.mfilter,tp,LOCATION_EXTRA,0,nil,e)
	local cond1=Duel.CheckPendulumZones(tp) and #pg>=2
	local cond2=Duel.IsExistingMatchingCard(c26067107.fusion,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	if #pg>0 and (cond1 or cond2) and Duel.SelectYesNo(tp,aux.Stringid(26067107,0)) then
		local op=Duel.SelectEffect(tp,
		{cond1,aux.Stringid(26067107,1)},
		{cond2,aux.Stringid(26067107,2)})
		if op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			tc=pg:Select(tp,2,2,nil)
			local pg=tc:GetFirst()
			for pg in aux.Next(tc) do
				Duel.MoveToField(pg,tp,tp,LOCATION_PZONE,POS_FACEUP,false)
				pg:SetStatus(STATUS_EFFECT_ENABLED,true)
			end
		elseif op==2 then
			local fc=Duel.SelectMatchingCard(tp,c26067107.fusion,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst()
			local mat=Duel.SelectFusionMaterial(tp,fc,mg)
			fc:SetMaterial(mat)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		end
	end
end