--Astelloy Crafter - Niclas
function c26063005.initial_effect(c)
	--Gemini
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_GEMINI_SUMMONABLE)
	c:RegisterEffect(e0)
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0a:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e0a:SetCode(EFFECT_ADD_TYPE)
	e0a:SetCondition(c26063005.gemini)
	e0a:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e0a)
	local e0b=e0a:Clone()
	e0b:SetCode(EFFECT_REMOVE_TYPE)
	e0b:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e0b)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Gemini.EffectStatusCondition)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(200)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--cannot remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Gemini.EffectStatusCondition)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3a)
	--cannot switch control
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e4)
	--cannot be banished
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(Gemini.EffectStatusCondition)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c26063005.rmlimit)
	c:RegisterEffect(e5)
	--normal summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26063005,0))
	e6:SetCategory(CATEGORY_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetTarget(c26063005.gtg)
	e6:SetOperation(c26063005.gop)
	c:RegisterEffect(e6)
	--summon eff
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(26063005,1))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetCountLimit(1,26063005)
	e7:SetCondition(Gemini.EffectStatusCondition)
	e7:SetTarget(c26063005.target)
	e7:SetOperation(c26063005.operation)
	c:RegisterEffect(e7)
	local e7a=e7:Clone()
	e7a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e7a)
	local e7b=e7:Clone()
	e7b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7b)
end
function c26063005.protval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER)
end
function c26063005.rmlimit(e,c,tp,r)
	return c==e:GetHandler() and r==REASON_EFFECT
end
function c26063005.gemini(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND) or Gemini.NormalStatusCondition(e)
end
function c26063005.infilter(c)
	Card.IsHasEffect(c,26063005)
end
function c26063005.gfilter(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_NORMAL)
end
function c26063005.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26063005.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26063005.gop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26063005.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c26063005.setfilter(c,e,tp)
	return c:IsSetCard(0x663) and not c:IsCode(26063005) and
		((c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() or
		 c:IsType(TYPE_MONSTER) and (c:IsMSetable(true,nil)) or c:IsCanBeSpecialSummoned(e,0,tp,true,true)) or 
		c:IsAbleToHand())
end
function c26063005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c26063005.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26063005.setfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c26063005.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26063005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local s1=tc:IsAbleToHand()
	local s2=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsType(TYPE_MONSTER) and (tc:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP)) or tc:IsMSetable(true,nil))
	local s3=tc:IsSSetable()
	local ops,opval,off={},{},1
	if s1 then
		ops[off]=aux.Stringid(26063005,2)
		opval[off-1]=1
		off=off+1
	end
	if s2 then
		ops[off]=aux.Stringid(26063005,3)
		opval[off-1]=2
		off=off+1
	end
	if s3 then
		ops[off]=aux.Stringid(26063005,4)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if opval[op]==2 then
		local pos=POS_FACEDOWN_DEFENSE
		if tc:IsCanBeSpecialSummoned(e,0,tp,true,true) then pos=pos+POS_FACEUP end
		local pos=Duel.SelectPosition(tp,tc,pos)
		if pos==POS_FACEDOWN_DEFENSE then 
			Duel.SpecialSummon(tc,0,tp,tp,false,false,pos)
			Duel.ConfirmCards(1-tp,tc)
		else
		Duel.SpecialSummon(tc,0,tp,tp,true,true,pos)
		end
	end
	if opval[op]==3 then
		Duel.SSet(tp,tc)
	end
end
