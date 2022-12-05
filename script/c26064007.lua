--Over-wind Planetarium
function c26064007.initial_effect(c)
	c:EnableCounterPermit(0xb6)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064007,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26064007.target)
	e1:SetOperation(c26064007.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c26064007.ctop)
	c:RegisterEffect(e2)
	--decrease ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c26064007.atktg)
	e3:SetValue(c26064007.atkval)
	c:RegisterEffect(e3)
	--when drawn
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DRAW)
	e4:SetCost(c26064007.spcost)
	e4:SetTarget(c26064007.drtg)
	e4:SetOperation(c26064007.drop)
	c:RegisterEffect(e4)
--leave field
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26064007,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c26064007.setcon)
	e5:SetOperation(c26064007.setop)
	c:RegisterEffect(e5)
	if not c26064007.global_check then
		c26064007.global_check=true
		c26064007[0]=0
		c26064007[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTargetRange(1,1)
		ge1:SetCountLimit(1)
		ge1:SetOperation(c26064007.stealdraw)
		Duel.RegisterEffect(ge1,0)
	end
end
function c26064007.afilter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c26064007.limit(e,c)
	return not c:IsType(TYPE_FLIP) and not c:IsSetCard(0x664)
end
function c26064007.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return not rc:IsSetCard(0x664) and not re:IsActiveType(TYPE_FLIP)
end
function c26064007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26064007.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c26064007.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c,c)
	if g:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		tg=sg:GetFirst()
		if tg and Duel.SendtoDeck(tg,nil,0,REASON_EFFECT) then
			--Prevent activations of other field spells
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_ACTIVATE)
			e0:SetRange(LOCATION_FZONE)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetTargetRange(1,0)
			e0:SetValue(c26064007.afilter)
			e0:SetReset(RESET_PHASE+PHASE_END,3)
			--c:RegisterEffect(e0)
			--cannot set
			local e0b=Effect.CreateEffect(c)
			e0b:SetType(EFFECT_TYPE_FIELD)
			e0b:SetCode(EFFECT_CANNOT_SSET)
			e0b:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			e0b:SetTargetRange(1,0)
			e0b:SetRange(LOCATION_FZONE)
			e0b:SetTarget(c26064007.sfilter)
			e0b:SetReset(RESET_PHASE+PHASE_END,3)
			--c:RegisterEffect(e0b)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_SKIP_TURN)
			e1:SetRange(LOCATION_FZONE)
			e1:SetTargetRange(0,1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e2:SetTargetRange(1,0)
			e2:SetTarget(c26064007.limit)
			e2:SetReset(RESET_PHASE+PHASE_END,3)
			Duel.RegisterEffect(e2,tp)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_ACTIVATE)
			e3:SetTarget(c26064007.aclimit)
			Duel.RegisterEffect(e3,tp)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CANNOT_ATTACK)
			e4:SetTargetRange(LOCATION_MZONE,0)
			e4:SetTarget(c26064007.limit)
			e4:SetReset(RESET_PHASE+PHASE_END,3)
			Duel.RegisterEffect(e4,tp)
		end
	end
end
function c26064007.sfilter(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c26064007.ctop(e,tp,eg,ep,ev,re,r,rp)
	--Duel.Hint(HINT_CARD,0,26064007)
	local ct=eg:GetCount()
	e:GetHandler():AddCounter(0xb6,ct)
end
function c26064007.atkval(e,c)
	return e:GetHandler():GetCounter(0xb6)*-100
end
function c26064007.atktg(e,c)
	return not c:IsType(TYPE_FLIP) and not (c:IsStatus(STATUS_SPSUMMON_TURN) or c:IsStatus(STATUS_SUMMON_TURN) or c:IsStatus(STATUS_FLIP_SUMMON_TURN))
end
function c26064007.thfilter(c,e,sp)
	return c:IsSetCard(0x664) and not c:IsCode(26064007) and c:IsAbleToHand()
end
function c26064007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26064007.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26064007.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	--Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26064007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
	end
end
function c26064007.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK) and re
end
function c26064007.setop(e,tp,eg,ep,ev,re,r,rp)
	local rp=re:GetHandlerPlayer()
	c26064007[rp]=c26064007[rp]+1
end
function c26064007.stealdraw(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rp=Duel.GetTurnPlayer()
	local dt=Duel.GetDrawCount(tp)
	if c26064007[rp]>0 and dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,0)
		Duel.Hint(HINT_CARD,rp,26064007)
		Duel.Draw(1-rp,dt,REASON_RULE)
		c26064007[rp]=c26064007[rp]-1
	end
end