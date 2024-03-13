--Siphantasy
function c26066010.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--place on field after being tributed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26066010,0))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,26066010)
	e2:SetTarget(c26066010.tftg)
	e2:SetOperation(c26066010.tfop)
	c:RegisterEffect(e2)
	--convert damage to deckout
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(c26066010.damcon)
	e5:SetOperation(c26066010.damop)
	c:RegisterEffect(e5)
	--extra material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(c26066010.cfilter)
	e4:SetValue(POS_FACEUP)
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4a:SetRange(LOCATION_SZONE)
	e4a:SetTargetRange(LOCATION_HAND,0)
	e4a:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
	e4a:SetLabelObject(e4)
	c:RegisterEffect(e4a)
	--magic drain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetLabel(0)
	e5:SetCountLimit(1)
	e5:SetCondition(c26066010.drcon)
	e5:SetOperation(c26066010.spdrain)
	c:RegisterEffect(e5)
	local e5a=e5:Clone()
	e5a:SetLabel(1)
	c:RegisterEffect(e5a)

end
function c26066010.cfilter(e,c)
	return c:IsTrap() and (c:IsFaceup() or c:GetControler()==e:GetHandlerPlayer())
end
function c26066010.sumtrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RELEASE)
end
function c26066010.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,tp,0)
end
function c26066010.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c26066010.drain(c,p)
	return c:IsTrap()
	and c:IsReleasableByEffect()
	and not Duel.IsExistingMatchingCard(c26066010.eqfilter,p,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,c:GetCode())
end
c26066010[0]=0
function c26066010.eqfilter(c,cd)
	return c:IsCode(cd) and c:IsFaceup()
end
function c26066010.drcon(e,tp,eg,ep,ev,re,r,rp)
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	return rp==e:GetLabel() and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsSetCard(0x666) and Duel.IsChainDisablable(ev) 
end
function c26066010.spdrain(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	local sg=Duel.GetMatchingGroup(c26066010.drain,p,LOCATION_HAND+LOCATION_DECK,0,nil,p)
	if #sg>0 and Duel.SelectYesNo(p,aux.Stringid(26066010,0)) then
		local sc=sg:Select(p,1,1,nil):GetFirst()
		Duel.SendtoGrave(sc,REASON_EFFECT+REASON_RELEASE)
		sc:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.BreakEffect()
	elseif ep~=tp and not re:GetHandler():IsSetCard(0x666) then Duel.NegateEffect(ev) end
end

function c26066010.damcon(e,tp,eg,ep,ev,re,r,rp)
	local dam=Duel.GetBattleDamage(1-tp)
	local val=math.floor(dam/400)
	return dam>=400 and Duel.IsPlayerCanDiscardDeck(1-tp,1)
end
function c26066010.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam=Duel.GetBattleDamage(1-tp)
	local val=math.floor(dam/400)
	Duel.DiscardDeck(1-tp,val,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	Duel.Hint(HINT_CARD,1-tp,26066010)
	Duel.ChangeBattleDamage(1-tp,dam-(#og*400))
end