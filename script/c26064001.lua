--Over-Wind Horloge
function c26064001.initial_effect(c)
--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064001,2))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c26064001.fliptg)
	e1:SetOperation(c26064001.flipop)
	c:RegisterEffect(e1)
--flip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c26064001.flip)
	c:RegisterEffect(e2)
--leave field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064001,3))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c26064001.setcon1)
	e3:SetTarget(c26064001.settg)
	e3:SetOperation(c26064001.setop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c26064001.setcon2)
	c:RegisterEffect(e4)
end
function c26064001.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x664)
end
function c26064001.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if e:GetHandler():GetFlagEffect(26064004)~=0 then
		Duel.SetChainLimit(aux.FALSE)
		Duel.Hint(HINT_CARD,0,26064004)
	end
end
function c26064001.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsType),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)
	local g2=Duel.GetMatchingGroup(c26064001.filter,tp,LOCATION_DECK,0,nil,c)
	if g1:GetCount()>0 and c:GetFlagEffect(26064001)~=0 and Duel.SelectYesNo(tp,aux.Stringid(26064001,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064001,1))
		local sg=g1:Select(tp,1,1,nil)
		if sg then
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064001,1))
		local sg=g2:Select(tp,1,1,nil)
		tg=sg:GetFirst()
		if tg then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tg,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
function c26064001.flip(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():RegisterFlagEffect(26064001,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26064001.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) or not c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26064001.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064001.setfilter(c)
	return c:IsMSetable(true,nil) or c:IsSSetable()
end
function c26064001.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return
	Duel.IsExistingMatchingCard(Card.IsMSetable,tp,LOCATION_HAND,0,1,nil,true,nil) or
	Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26064001.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26064001.setfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,527)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		local s1=tc:IsMSetable(true,nil)
		local s2=tc:IsSSetable()
		if (s1 and s2) or not s2 then
			Duel.MSet(tp,tc,true,nil)
		else
			Duel.SSet(tp,tc,tp,false)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetProperty(EFFECT_FLAG_IMMEDIATELY_APPLY)
			e1:SetCountLimit(1)
			e1:SetOperation(c26064001.drop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp,true)
		end
	end
end
function c26064001.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26064001)
	Duel.Draw(tp,1,REASON_EFFECT)
end