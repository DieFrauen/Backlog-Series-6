--Entrophys Alembis
function c26065001.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c26065001.pscon)
	c:RegisterEffect(e0)
	--link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c26065001.synlimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26065001,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCode(EVENT_CHAINING)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{26065001,0})
	e2:SetCondition(c26065001.condition)
	e2:SetOperation(c26065001.operation)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26065001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,{26065001,1})
	e3:SetCondition(c26065001.spcon)
	e3:SetTarget(c26065001.sptg)
	e3:SetOperation(c26065001.spop)
	c:RegisterEffect(e3)
end

function c26065001.pscon(e,se,sp,st)
	return Duel.IsPlayerAffectedByEffect(sp,26067018) and (st&SUMMON_TYPE_PENDULUM)~=0 
end
function c26065001.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x665)
end
function c26065001.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return (rc:IsSetCard(0x665) or rc:IsType(TYPE_MONSTER)) and rc~=e:GetHandler()
end
function c26065001.thfilter(c)
	return c:IsSetCard(0x665) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c26065001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26065001.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_ONFIELD)
end
function c26065001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26065001.thfilter),tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	--spirit
	c:RegisterFlagEffect(FLAG_SPIRIT_RETURN,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetDescription(1104)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetRange(LOCATION_ONFIELD)
	e0:SetCountLimit(1)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	e0:SetCondition(Spirit.MandatoryReturnCondition)
	e0:SetTarget(Spirit.MandatoryReturnTarget)
	e0:SetOperation(Spirit.ReturnOperation)
	c:RegisterEffect(e0)
	local e0b=e0:Clone()
	e0b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0b:SetCondition(Spirit.OptionalReturnCondition)
	e0b:SetTarget(Spirit.OptionalReturnTarget)
	c:RegisterEffect(e0b)
end

function c26065001.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function c26065001.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26065001.cansstk(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		   Duel.IsPlayerCanSpecialSummonMonster(tp,26065101,0,TYPES_TOKEN+TYPE_SPIRIT,1000,1000,2,RACE_AQUA,ATTRIBUTE_WIND)
end
function c26065001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c26065001.cansstk(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c26065001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,26065101,0,TYPES_TOKEN,1000,1000,3,RACE_AQUA,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,26065101)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end