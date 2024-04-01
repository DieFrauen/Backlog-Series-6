--Over-Wind Rasmus
function c26064003.initial_effect(c)
--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064003,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c26064003.fliptg)
	e1:SetOperation(c26064003.flipop)
	c:RegisterEffect(e1)
--flip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c26064003.flip)
	c:RegisterEffect(e2)
--leave field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064003,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetCountLimit(1,26064003)
	e3:SetCondition(c26064003.setcon1)
	e3:SetTarget(c26064003.settg)
	e3:SetOperation(c26064003.setop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetCode(EVENT_LEAVE_FIELD)
	e3a:SetCondition(c26064003.setcon2)
	c:RegisterEffect(e3a)
--tribute set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26064003,0))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_PROC)
	e4:SetCondition(c26064003.otcon)
	c:RegisterEffect(e4)
end
c26064003.FLIP=true
c26064003.TURN=true
function c26064003.otcon(e,c,minc)
	if c==nil then return true end
	return c:GetLevel()>4 and minc<=1
end
function c26064003.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x664)
	if chk==0 then return true end
	if chk==2 then return #g>0 end
	if e:GetHandler():GetFlagEffect(26064004)~=0 then
		Duel.SetChainLimit(aux.FALSE)
		Duel.Hint(HINT_CARD,0,26064004)
	end
end
function c26064003.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x664)
	if g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064003,1))
		local sg=g:Select(tp,1,1,nil)
		tg=sg:GetFirst()
		if tg then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tg,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
function c26064003.flip(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():RegisterFlagEffect(26064003,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26064003.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) or not c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26064003.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064003.setfilter1(c,tp)
	return  c:IsSSetable() and Duel.IsExistingMatchingCard(c26064003.setfilter2,tp,LOCATION_HAND,0,1,c)
end
function c26064003.setfilter2(c)
	return c:IsMSetable(true,nil)
end
function c26064003.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c26064003.setfilter1,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c26064003.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c26064003.setfilter1,tp,LOCATION_HAND,0,1,nil,tp) then return end
	tc1=Duel.SelectMatchingCard(tp,c26064003.setfilter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	tc2=Duel.SelectMatchingCard(tp,c26064003.setfilter2,tp,LOCATION_HAND,0,1,1,tc1):GetFirst()
	Duel.SSet(tp,tc1,tp,false)
	Duel.MSet(tp,tc2,true,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IMMEDIATELY_APPLY)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetLabel(2)
	e1:SetOperation(c26064003.draw)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp,true)
end
function c26064003.draw(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,26064003)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end