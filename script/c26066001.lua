--Siphanteon Paradox Marshal - Styxus
function c26066001.initial_effect(c)
	--summon with 3 tribute
	local e1=aux.AddNormalSummonProcedure(c,true,true,3,3,SUMMON_TYPE_TRIBUTE,aux.Stringid(26066001,0))
	--tribute check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c26066001.valcheck)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c26066001.regcon)
	e3:SetOperation(c26066001.regop)
	c:RegisterEffect(e3)
	e3:SetLabelObject(e2)
end
function c26066001.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		typ=typ|tc:GetOriginalType()&0x7
	end
	e:SetLabel({typ,#g})
end
function c26066001.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsTributeSummoned()
		and e:GetLabelObject():GetLabel()~=0
end
function c26066001.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ,gc=e:GetLabelObject():GetLabel()
	if typ&0x7==0x7 then
		--destroy all
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(26066001,1))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCountLimit(1)
		e1:SetCost(c26066001.descost)
		e1:SetTarget(c26066001.destg)
		e1:SetOperation(c26066001.desop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	if gc>=2 then
		--Banish 3 of each
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26066001,2))
		e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DECKDES)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_RELEASE)
		e2:SetTarget(c26066001.b3tg)
		e2:SetOperation(c26066001.b3op)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_DISABLE)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EVENT_DESTROY)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DELAY|EFFECT_FLAG_CLIENT_HINT)
		e3:SetCondition(c26066001.b3con)
		c:RegisterEffect(e3)
	end
	if gc==3 then
		--Cannot be destroyed
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(26066001,3))
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CLIENT_HINT)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e4:SetValue(1)
		e4:SetCondition(c26066001.indescon)
		e4:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_DISABLE)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetValue(aux.tgoval)
		e5:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_DISABLE)
		c:RegisterEffect(e5)
	end
end
function c26066001.indescon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function c26066001.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function c26066001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c26066001.match(c,g1,g2)
	return g1:IsExists(Card.IsCode,1,nil,c:GetCode())
	--or g2:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c26066001.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
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
function c26066001.b3filter(c,tp)
	return c:IsReason(REASON_BATTLE|REASON_EFFECT)
end
function c26066001.b3con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26066001.b3filter,1,nil,tp)
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
		local dg=Duel.GetDecktopGroup(p,1)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end