--Hierosiphantom Marshal - Styxus
function c26066001.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--summon with 3 tribute
	local e1=aux.AddNormalSummonProcedure(c,true,false,3,3,SUMMON_TYPE_TRIBUTE,aux.Stringid(26066001,0))
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
	e3:SetCost(c26066001.cost)
	e3:SetCondition(c26066001.condition)
	e3:SetTarget(c26066001.target)
	e3:SetOperation(c26066001.operation)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Banish 3 of each
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26066001,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c26066001.b3tg)
	e4:SetOperation(c26066001.b3op)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	--Cannot be destroyed
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	e5:SetCondition(c26066001.indescon)
	c:RegisterEffect(e5)
end
function c26066001.indescon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
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
function c26066001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function c26066001.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function c26066001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local typ=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,nil,typ)
	if chk==0 then return #g>0 and c:GetFlagEffect(26066001)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	c:RegisterFlagEffect(26066001,RESET_CHAIN,0,1)
end
function c26066001.match(c,g1,g2)
	return g1:IsExists(Card.IsCode,1,nil,c:GetCode()) or g2:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c26066001.operation(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabelObject():GetLabel()
	local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,typ)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil,typ)
	local d1=Duel.GetMatchingGroup(c26066001.match,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,g1,g2)
	local d2=Duel.GetMatchingGroup(c26066001.match,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,g2,g1)
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
function c26066001.END(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c)
end
function c26066001.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==1
end
function c26066001.b3tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c26066001.END,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	if chk==0 then return aux.SelectUnselectGroup(rg,e,tp,3,3,c26066001.rescon,0) and c:GetFlagEffect(26066001)==0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rsg,3,0,0)
	c:RegisterFlagEffect(26066001,RESET_CHAIN,0,1)
end
function c26066001.b3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c26066001.END,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	local sg=aux.SelectUnselectGroup(rg,e,tp,3,3,c26066001.rescon,1,tp,HINTMSG_REMOVE)
	Duel.HintSelection(sg)
	if #sg>0 and Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)~=0 then
		local p=sg:GetFirst():GetOwner()
		Duel.DiscardDeck(p,1,REASON_EFFECT)
	end
end