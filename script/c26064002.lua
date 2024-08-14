--Over-Wind Olomouc
function c26064002.initial_effect(c)
--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064002,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c26064002.fliptg)
	e1:SetOperation(c26064002.flipop)
	c:RegisterEffect(e1)
--flip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c26064002.flip)
	c:RegisterEffect(e2)
--leave field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064002,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c26064002.setcon1)
	e3:SetTarget(c26064002.settg)
	e3:SetOperation(c26064002.setop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c26064002.setcon2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26064002,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetTarget(c26064002.ns)
	c:RegisterEffect(e5)
end
c26064002.FLIP=true
c26064002.TURN=true
function c26064002.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x664)
end
function c26064002.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	local g2=Duel.GetMatchingGroup(c26064001.filter,tp,LOCATION_DECK,0,nil,c)
	if chk==0 then return true end
	if chk==2 then return #g1>0 or #g2>0 end
	if e:GetHandler():GetFlagEffect(26064004)~=0 then
		Duel.SetChainLimit(aux.FALSE)
		Duel.Hint(HINT_CARD,0,26064004)
	end
end
function c26064002.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsType),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	local g2=Duel.GetMatchingGroup(c26064002.filter,tp,LOCATION_DECK,0,nil,c)
	if g1:GetCount()>0 and c:GetFlagEffect(26064002)~=0 and Duel.SelectYesNo(tp,aux.Stringid(26064002,4)) then 
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064002,1))
		local sg=g1:Select(tp,1,1,nil)
		if sg then
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064002,1))
		local sg=g2:Select(tp,1,1,nil)
		tg=sg:GetFirst()
		if tg then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tg,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
function c26064002.flip(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():RegisterFlagEffect(26064002,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26064002.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) or not c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26064002.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064002.setfilter(c)
	return c:IsMSetable(true,nil) or c:IsSSetable()
end
function c26064002.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return
	Duel.IsExistingMatchingCard(Card.IsMSetable,tp,LOCATION_HAND,0,1,nil,true,nil) or
	Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26064002.refilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c26064002.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26064002.setfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,527)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		local s1=tc:IsMSetable(true,nil)
		local s2=tc:IsSSetable()
		if (s1 and s2) or not s2 then
			--Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.MSet(tp,tc,true,nil)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetOperation(c26064002.drop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp,true)
		else
			Duel.SSet(tp,tc,tp,false)
		end
	end
end
function c26064002.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<0
end
function c26064002.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26064002)
	Duel.Draw(tp,1,REASON_EFFECT)
	e:Reset()
end
function c26064002.ns(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=c26064002.fliptg(e,tp,eg,ep,ev,re,r,rp,2)
	local b2=c26064002.settg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 end
	local ops={}
	local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(26064002,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(26064002,1)
			opval[off-1]=2
			off=off+1
		end
	local op=0
	if (b1 or b2) then
		op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			e:SetCategory(CATEGORY_TODECK)
			e:SetProperty(0)
			e:SetOperation(c26064002.flipop)
			c26064002.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
			e:GetHandler():RegisterFlagEffect(26064002,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		if opval[op]==2 then
			e:SetCategory(CATEGORY_DRAW)
			e:SetProperty(0)
			e:SetOperation(c26064002.setop)
			c26064002.settg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end