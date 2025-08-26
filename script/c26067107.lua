--The Desceptim Marshal - Bael
function c26067107.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--destroy and create pendulum scales
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
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
	local sc=c:GetLeftScale()
	return c:IsSetCard(0x667) and c:IsType(TYPE_PENDULUM)   
	and c:IsFaceup() and not c:IsForbidden() and (sc==6 or sc==8)
end
function c26067107.thfilter(c)
	return c:IsSetCard(0x667) and not c:IsCode(26067007) and c:IsAbleToHand()
end
function c26067107.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLeftScale)==#sg
end
function c26067107.deop(e,tp,eg,ep,ev,re,r,rp)
	local cost1=math.min(Duel.GetLP(tp),1400)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	local pg=Duel.GetMatchingGroup(c26067107.pcfilter,tp,LOCATION_EXTRA,0,nil)
	local hg=Duel.GetMatchingGroup(c26067107.thfilter,tp,LOCATION_DECK,0,nil)
	local p1=Duel.CheckPendulumZones(tp)
	and aux.SelectUnselectGroup(pg,e,tp,2,2,c26067107.rescon,0)
	and Duel.GetFlagEffect(tp,26067007)==0
	local p2=#hg>0
	and Duel.GetFlagEffect(tp,26067107)==0
	and Duel.CheckLPCost(tp,cost1)
	if (p1 or p2) and Duel.SelectYesNo(tp,aux.Stringid(26067007,0)) then
		local op=Duel.SelectEffect(tp,
		{p1,aux.Stringid(26067107,1)},
		{p2,aux.Stringid(26067107,2)})
		if op==1 then
			Duel.PayLPCost(tp,cost1)
			local sg=aux.SelectUnselectGroup(pg,e,tp,2,2,c26067107.rescon,1,tp,HINTMSG_TOFIELD)
			local pc1,pc2=sg:GetFirst(),sg:GetNext()
			if Duel.MoveToField(pc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
				if Duel.MoveToField(pc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
					pc2:SetStatus(STATUS_EFFECT_ENABLED,true)
				end
				pc1:SetStatus(STATUS_EFFECT_ENABLED,true)
			end
			Duel.RegisterFlagEffect(tp,26067007,RESET_PHASE+PHASE_END,0,1)
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=hg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.RegisterFlagEffect(tp,26067107,RESET_PHASE+PHASE_END,0,1)
		end
	end
end