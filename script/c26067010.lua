--Desceptim Praestigis
function c26067010.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--stack GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabelObject(nil)
	e1:SetOperation(c26067010.redir1)
	c:RegisterEffect(e1)
	--stack on opponents gy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabelObject(nil)
	e2:SetLabel(0)
	e2:SetOperation(c26067010.redir2)
	c:RegisterEffect(e2)
	--stack on opponents main deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26067010,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c26067010.txtg)
	e3:SetOperation(c26067010.txop)
	c:RegisterEffect(e3)
	--cannot ss from exta
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(c26067010.sumlimit)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c26067010.redir1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc then
		--Duel.Hint(HINT_CARD,tp,26067010)
		Duel.MoveSequence(e:GetLabelObject(),1)
	else
		local tg=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
		nc=tg:GetFirst()
		if #tg>0 and nc:IsSetCard(0x667) and nc:GetOwner()==tp then
			e:SetLabelObject(nc)
		else
			e:SetLabelObject(nil)
		end
	end
end
function c26067010.redir2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local lab=e:GetLabel()
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local dc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if tc and dc~=tc and #dg~=lab and dg:IsContains(tc) then
		Duel.Hint(HINT_CARD,1-tp,26067010)
		Duel.MoveToDeckTop(tc)
		tc:ReverseInDeck()
	else
		local nc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
		if nc and nc:IsSetCard(0x667) and nc:GetOwner()==tp and nc:IsFaceup() then
			e:SetLabelObject(nc)
			e:SetLabel(#dg)
		else
			e:SetLabelObject(nil)
		end
	end
end
function c26067010.exfilter(c)
	return c:IsCode(26067007) and c:GetSequence()>4 and c:IsAbleToChangeControler()
end
function c26067010.txtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c26067010.exfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26067010.exfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c26067010.txop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		Duel.SendtoExtraP(tc,1-tp,REASON_EFFECT)
	end
end
function c26067010.bael(c,g)
	return c:IsCode(26067007) and c:GetSequence()==g-1
end
function c26067010.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	local tp=1-e:GetHandlerPlayer()
	local xg=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	local xc=Duel.GetFieldCard(tp,LOCATION_EXTRA,xg-1)
	return xc and xc:IsFaceup() and xc:IsCode(26067007) and c:GetSequence()<xc:GetSequence() and c:IsLocation(LOCATION_EXTRA)
end
function c26067010.pcfilter(c)
	return c:IsSetCard(0x667) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end