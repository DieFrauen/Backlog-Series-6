--Over-wind Singularity
function c26064008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetTarget(c26064008.target1)
	c:RegisterEffect(e1)
	--when drawn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26064005,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetCost(c26064008.cost2)
	e2:SetTarget(c26064008.target2)
	c:RegisterEffect(e2)
	--leave field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c26064008.setcon)
	e3:SetTarget(c26064008.target3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c26064008.setcon2)
	c:RegisterEffect(e4)
end

function c26064008.filter1(c,e,tp,eg,ep,ev,re,r,rp,tid)
	return c:IsSetCard(0x664) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and (
	(c:IsCode(26064001) and c26064001.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064002) and c26064002.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064003) and c26064003.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064004) and c26064004.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064005) and c26064005.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064006) and c26064006.target(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064009) and c26064009.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064010) and c26064010.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064011) and c26064011.fliptg(e,tp,eg,ep,ev,re,r,rp,0))) 
	 and (c:IsOnField() or c:GetTurnID()==tid)
end
function c26064008.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local g1=Duel.GetMatchingGroup(c26064008.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e,tp,eg,ep,ev,re,r,rp,tid)
	if chk==0 then return #g1>0 end
	local op=g1:Select(tp,1,1,nil):GetFirst():GetCode()
	if op==26064001 then
		e:SetCategory(CATEGORY_TODECK)
		e:SetOperation(c26064001.flipop)
		c26064001.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064002 then
		e:SetCategory(CATEGORY_TODECK)
		e:SetOperation(c26064002.flipop)
		c26064002.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064003 then
		e:SetOperation(c26064003.flipop)
		c26064003.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064004 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetOperation(c26064004.flipop)
		c26064004.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064005 then
		e:SetCategory(CATEGORY_POSITION)
		e:SetOperation(c26064005.flipop)
		c26064005.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064006 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c26064006.activate)
		c26064006.target(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064009 then
		e:SetCategory(CATEGORY_POSITION)
		e:SetOperation(c26064009.flipop)
		c26064009.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064010 then
		e:SetCategory(CATEGORY_POSITION)
		e:SetOperation(c26064010.flipop)
		c26064010.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064011 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c26064011.flipop)
		c26064011.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c26064008.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064008.filter2(c,e,tp,eg,ep,ev,re,r,rp,tid)
	return c:IsSetCard(0x664) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and (
	(c:IsCode(26064004) and c26064004.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064005) and c26064005.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064006) and c26064006.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064009) and c26064009.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064010) and c26064010.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064011) and c26064011.drtg(e,tp,eg,ep,ev,re,r,rp,0))) 
	 and (c:IsOnField() or c:GetTurnID()==tid)
end
function c26064008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local g1=Duel.GetMatchingGroup(c26064008.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e,tp,eg,ep,ev,re,r,rp,tid)
	if chk==0 then return #g1>0 end
	local op=g1:Select(tp,1,1,nil):GetFirst():GetCode()
	if op==26064004 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetOperation(c26064004.drop)
		c26064004.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064005 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetOperation(c26064005.drop)
		c26064005.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064006 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c26064006.drop)
		c26064006.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064009 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetOperation(c26064009.drop)
		c26064009.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064010 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetOperation(c26064010.drop)
		c26064010.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064011 then
		e:SetOperation(c26064011.drop)
		c26064011.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c26064008.setcon(e,tp,eg,ep,ev,re,r,rp)
	return re and not e:GetHandler():IsLocation(LOCATION_DECK) 
end
function c26064008.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return re and not e:GetHandler():GetPreviousLocation(LOCATION_ONFIELD)
end
function c26064008.filter3(c,e,tp,eg,ep,ev,re,r,rp,tid)
	return c:IsSetCard(0x664) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and (
	(c:IsCode(26064001) and c26064001.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064002) and c26064002.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064003) and c26064003.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064004) and c26064004.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064005) and c26064005.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:IsCode(26064009) and c26064009.settg(e,tp,eg,ep,ev,re,r,rp,2)) or
	(c:IsCode(26064010) and c26064010.settg(e,tp,eg,ep,ev,re,r,rp,2)) or
	(c:IsCode(26064011) and c26064011.settg(e,tp,eg,ep,ev,re,r,rp,2))) 
	 and (c:IsOnField() or c:GetTurnID()==tid)
end
function c26064008.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local g1=Duel.GetMatchingGroup(c26064008.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e,tp,eg,ep,ev,re,r,rp,tid)
	if chk==0 then return #g1>0 end
	local op=g1:Select(tp,1,1,nil):GetFirst():GetCode()
	if op==26064001 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetOperation(c26064001.setop)
		c26064001.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064002 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetOperation(c26064002.setop)
		c26064002.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064003 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetOperation(c26064003.setop)
		c26064003.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064004 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetOperation(c26064004.setop)
		c26064004.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064005 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
		e:SetOperation(c26064005.setop)
		c26064005.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064009 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetOperation(c26064009.setop)
		c26064009.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064010 then
		e:SetCategory(CATEGORY_TODECK)
		e:SetOperation(c26064010.setop)
		c26064010.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064011 then
		e:SetCategory(CATEGORY_TODECK)
		e:SetOperation(c26064011.setop)
		c26064011.settg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end