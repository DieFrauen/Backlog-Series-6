--Hierosiphantom Marshal - Styxus
function c26066001.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--summon with 3 tribute
	local e0a=aux.AddNormalSummonProcedure(c,true,false,3,3,SUMMON_TYPE_TRIBUTE,aux.Stringid(26066001,0))
	local e0b=aux.AddNormalSetProcedure(c)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(c26066001.nsfilter))
	e1:SetValue(POS_FACEUP)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetTargetRange(LOCATION_HAND,0)
	e1a:SetCondition(c26066001.nscon)
	c:RegisterEffect(e1a)
	--tribute check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c26066001.valcheck)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26066001,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c26066001.condition)
	e3:SetTarget(c26066001.target)
	e3:SetOperation(c26066001.operation)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Banish 3 of each
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c26066001.adjustop)
	c:RegisterEffect(e2)
end
function c26066001.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		typ=typ|tc:GetOriginalType()&0x7
	end
	e:SetLabel(typ)
end
function c26066001.nscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),26066007)
end
function c26066001.nsfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c26066001.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function c26066001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local typ=e:GetLabelObject():GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,e:GetHandler(),typ)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c26066001.match(c,g)
	return g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c26066001.operation(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabelObject():GetLabel()
	local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler(),typ)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD+LOCATION_HAND,e:GetHandler(),typ)
	local d1=Duel.GetMatchingGroup(c26066001.match,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,g1)
	local d2=Duel.GetMatchingGroup(c26066001.match,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,g2)
	d1:Merge(g1)
	d2:Merge(g2)
	local sp1,sp2=Group.CreateGroup(),Group.CreateGroup()
	for tc in aux.Next(d1) do
		if d1:FilterCount(Card.IsCode,nil,tc:GetCode())==1 then
		sp1:AddCard(tc) end
	end
	d1:Sub(sp1)
	for tc in aux.Next(d2) do
		if d2:FilterCount(Card.IsCode,nil,tc:GetCode())==1 then
		sp2:AddCard(tc) end
	end
	d2:Sub(sp2)
	d1:Merge(g1);d2:Merge(g2)
	local sc1=d1:GetClassCount(Card.GetCode)
	local sg1=aux.SelectUnselectGroup(d1,e,tp,sc1,sc1,aux.dncheck,1,tp,HINTMSG_TODECK,aux.dncheck)
	sg1:Merge(sp1)
	local sc2=d2:GetClassCount(Card.GetCode)
	local sg2=aux.SelectUnselectGroup(d2,e,1-tp,sc2,sc2,aux.dncheck,1,1-tp,HINTMSG_TODECK,aux.dncheck)
	sg2:Merge(sp2)
	Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD,LOCATION_HAND))
	Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_HAND,0))
	sg1:Merge(sg2)
	Duel.Destroy(sg1,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	Duel.ShuffleHand(1-tp)
	Duel.ShuffleHand(tp)
end
function c26066001.END(c,g)
	return g:IsExists(Card.IsCode,3,nil,c:GetCode())
end
function c26066001.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local sg1=g1:Filter(c26066001.END,nil,g1)
	local sg2=g2:Filter(c26066001.END,nil,g2)
	local readjust=false
	local fil3=nil
	if #sg1>0 then
		Duel.Hint(HINT_CARD,tp,26066001)
		for tc in aux.Next(sg1) do
			if tc:IsLocation(LOCATION_GRAVE) then
				fil3=sg1:Filter(Card.IsCode,nil,tc:GetCode())
				Duel.HintSelection(fil3)
				Duel.Remove(fil3,POS_FACEDOWN,REASON_RULE)
			end
		end
		local bg=(math.floor(Duel.GetMatchingGroupCount(Card.IsFacedown,0,LOCATION_REMOVED,0,nil)/3))
		Duel.DiscardDeck(tp,math.min(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),3),REASON_EFFECT)
		readjust=true
	end
	if #sg2>0 then
		Duel.Hint(HINT_CARD,tp,26066001)
		for tc in aux.Next(sg2) do
			if tc:IsLocation(LOCATION_GRAVE) then
				fil3=sg2:Filter(Card.IsCode,nil,tc:GetCode())
				Duel.HintSelection(fil3)
				Duel.Remove(fil3,POS_FACEDOWN,REASON_RULE)
			end
		end
		local bg=(math.floor(Duel.GetMatchingGroupCount(Card.IsFacedown,0,0,LOCATION_REMOVED,nil)/3))
		Duel.DiscardDeck(1-tp,math.min(Duel.GetFieldGroupCount(tp,0,LOCATION_DECK),3),REASON_EFFECT)
		readjust=true
	end
	if readjust then 
		Duel.Readjust()
	end
end