--Over-Wind Olsen
function c26064000.initial_effect(c)
--tribute set
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26064000,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SET_PROC)
	e0:SetCondition(c26064000.otcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064000,1))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c26064000.sumtg)
	e1:SetOperation(c26064000.sumop)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26064000,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e2:SetTarget(c26064000.fliptg)
	e2:SetOperation(c26064000.flipop)
	c:RegisterEffect(e2)
	--flip
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2b:SetOperation(c26064000.flip)
	c:RegisterEffect(e2b)
--leave field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064001,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c26064000.setcon1)
	e3:SetTarget(c26064000.settg)
	e3:SetOperation(c26064000.setop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetCode(EVENT_LEAVE_FIELD)
	e3a:SetCondition(c26064000.setcon2)
	c:RegisterEffect(e3a)
	
end
function c26064000.otcon(e,c,minc)
	if c==nil then return true end
	return c:GetLevel()>4 and minc<=1
end
function c26064000.cfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_FLIP)
end
function c26064000.sumtg(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=e:GetHandlerPlayer()
	local g1=Duel.GetMatchingGroup(c26064000.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return #g1>0
end
function c26064000.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26064000.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:Select(tp,1,1,nil)
	if tg and Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE) then return true
	else return false end
end

function c26064000.flip(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():RegisterFlagEffect(26064000,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26064000.filter(c,e,fl)
	return c:IsCanBeEffectTarget(e) and c:IsAbleToHand() and (c:IsSetCard(0x664) or fl)
end
function c26064000.fliptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local fl=false
	if e:GetHandler():GetFlagEffect(26064000)~=0 then fl=true end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26064000.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26064000.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,fl)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c26064000.flipop(e,tp,eg,ep,ev,re,r,rp)
	local dct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		aux.ToHandOrElse(tc,tp,function(c) return dct>1 end,
		function(c)
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			Duel.ConfirmDecktop(tp,1) end,
		aux.Stringid(26064000,5))
	end
end
function c26064000.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26064000.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064000.setfilter(c)
	return c:IsMSetable(true,nil) or c:IsSSetable()
end
function c26064000.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c26064000.setfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c26064000.thfilter(c,s3)
	return c:IsSetCard(0x664) and c:IsAbleToHand() and (
	(c:IsType(TYPE_MONSTER) and s3==1) or
	(c:IsType(TYPE_FIELD  ) and s3==3) or
	(c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and s3==2)	)
end
function c26064000.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26064000.setfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,527)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		local s1=tc:IsMSetable(true,nil)
		local s2=tc:IsSSetable()
		local s3=nil
		if (s1 and s2) or not s2 then
			Duel.MSet(tp,tc,true,nil)
			s3=1 
		else
			Duel.SSet(tp,tc,tp,false)
			if tc:GetSequence()>4 then s3=3 else s3=2 end
		end
		local g=Duel.IsExistingMatchingCard(c26064000.thfilter,tp,LOCATION_DECK,0,1,nil,s3)
		if g and Duel.SelectYesNo(tp,aux.Stringid(26064000,4)) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IMMEDIATELY_APPLY)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetCountLimit(1)
			e1:SetLabel(s3)
			e1:SetOperation(c26064000.th)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp,true)
		end
	end
end
function c26064000.th(e,tp,eg,ep,ev,re,r,rp)
	local s3=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c26064000.thfilter,tp,LOCATION_DECK,0,1,1,nil,s3)
	if #g>0 then
		Duel.Hint(HINT_CARD,tp,26064000)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
