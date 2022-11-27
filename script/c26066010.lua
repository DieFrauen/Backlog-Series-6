--Desceptim Praestigis
function c26066010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--stack on opponents gy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26066010,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c26066010.tgtg)
	e2:SetOperation(c26066010.tgop)
	c:RegisterEffect(e2)
	--stack on opponents extra
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26066010,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c26066010.txtg)
	e3:SetOperation(c26066010.txop)
	c:RegisterEffect(e3)
	--create pendulum scales
	local e4=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26066010,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_BOTH_SIDE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(c26066010.detg)
	e4:SetOperation(c26066010.deop)
	c:RegisterEffect(e4)
	
end

function c26066010.pcfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToGrave() and c:IsAbleToChangeControler()
end
function c26066010.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c26066010.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c26066010.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.SendtoGrave(tc,REASON_EFFECT,1-tp)
		e:GetHandler():SetCardTarget(tc)
		e:SetLabelObject(tc)
		--destroy redirect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetDescription(aux.Stringid(26066010,3))
		e1:SetLabelObject(tc)
		e1:SetOperation(c26066010.redir)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c26066010.redir(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc then
		Duel.Hint(HINT_CARD,tp,26066010)
		Duel.MoveSequence(e:GetLabelObject(),1)
	end
end
function c26066010.exfilter(c)
	return c:IsCode(26066007) and c:GetSequence()>4 and c:IsAbleToChangeControler()
end
function c26066010.txtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c26066010.exfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26066010.exfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c26066010.txop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		Duel.SendtoExtraP(tc,1-tp,REASON_EFFECT)
		e:GetHandler():SetCardTarget(tc)
		e:SetLabelObject(tc)
		--cannot ss from exta
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetRange(LOCATION_SZONE)
		e1:SetDescription(aux.Stringid(26066010,4))
		e1:SetTargetRange(0,1)
		e1:SetTarget(c26066010.sumlimit)
		e1:SetLabelObject(e)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c26066010.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	local seq=e:GetLabelObject():GetLabelObject():GetSequence()
	return c:IsLocation(LOCATION_EXTRA) and c:GetSequence()<seq
end
function c26066010.pcfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end
function c26066010.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c26066010.pcfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
		return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
			and g:GetClassCount(Card.GetCode)>=1
	end
end
function c26066010.deop(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetMatchingGroup(c26066010.pcfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	if #pg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		tc=pg:Select(tp,1,2,nil)
		local pg=tc:GetFirst()
		for pg in aux.Next(tc) do
			Duel.MoveToField(pg,tp,tp,LOCATION_PZONE,POS_FACEUP,false)
			pg:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		Duel.Draw(1-tp,#tc,REASON_EFFECT)
	end
end