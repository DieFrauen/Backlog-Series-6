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
	e1:SetValue(400)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Material effects
		local e1m=Effect.CreateEffect(c)
		e1m:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
		e1m:SetCode(EFFECT_UPDATE_ATTACK)
		e1m:SetCondition(c26063005.xmcond)
		e1m:SetTargetRange(LOCATION_MZONE,0)
		e1m:SetValue(400)
		e1m:SetTarget(c26063005.xmtg)
		c:RegisterEffect(e1m)
		local e2m=e1m:Clone()
		e2m:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2m)
	--cannot remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Gemini.EffectStatusCondition)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--material effects
		local e3m=Effect.CreateEffect(c)
		e3m:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
		e3m:SetCondition(c26063005.xmcond)
		e3m:SetTargetRange(LOCATION_MZONE,0)
		e3m:SetTarget(c26063005.xmtg)
		c:RegisterEffect(e3m)
	local e3a=e3:Clone()
	e3a:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3a)
	--material effects
		local e3ma=e3m:Clone()
		e3ma:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e3ma)
	local e3b=Effect.CreateEffect(c)
	e3b:SetType(EFFECT_TYPE_SINGLE)
	e3b:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e3b:SetCondition(Gemini.EffectStatusCondition)
	e3b:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_LINK))
	c:RegisterEffect(e3b)
	--material effects
		local e3mb=e3m:Clone()
		e3mb:SetCode(EFFECT_CANNOT_BE_MATERIAL)
		e3mb:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_LINK))
		c:RegisterEffect(e3mb)
	--normal summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26063005,0))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c26063005.gtg)
	e4:SetOperation(c26063005.gop)
	c:RegisterEffect(e4)
	--summon eff
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26063005,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,26063005)
	e5:SetCondition(Gemini.EffectStatusCondition)
	e5:SetTarget(c26063005.target)
	e5:SetOperation(c26063005.operation)
	c:RegisterEffect(e5)
	local e5a=e5:Clone()
	e5a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5a)
	local e5b=e5:Clone()
	e5b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5b)
end
function c26063005.xmcond(e,tp,eg,ep,ev,re,r,rp)
	local c,tp=e:GetHandler(),e:GetHandlerPlayer()
	if Duel.IsPlayerAffectedByEffect(tp,26068010) and c:IsType(TYPE_EFFECT) then return c==e:GetHandler() end
	return c:IsGeminiStatus() and c.StelloyEff1~=nil 
end
function c26063005.xmtg(e,c)
	local ec,tp=e:GetHandler(),e:GetHandlerPlayer()
	if Duel.IsPlayerAffectedByEffect(tp,26068010) and c:IsType(TYPE_EFFECT) then return c==e:GetHandler() end
	if ec:IsGeminiStatus() and ec.StelloyEff1~=nil  then
	return ec.ovmtg(e,c) end
end
function c26063005.protval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER)
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
	if not tc:IsRelateToEffect(e) then return end 
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
