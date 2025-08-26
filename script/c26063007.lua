--Castelloy Regalia - Braise
function c26063007.initial_effect(c)
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_GEMINI),4,2,nil,nil)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetDescription(aux.Stringid(26063007,0))
	e0:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e0:SetTargetRange(POS_FACEUP_ATTACK,0)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(c26063007.xtg)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26063007,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c26063007.cost)
	e1:SetTarget(c26063007.target)
	e1:SetOperation(c26063007.operation)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
end
function c26063007.xtg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local rk=c:GetRank()
	local g=c:GetOverlayGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local sg=g:Select(tp,0,1,nil)
		if #sg>0 then
			local code=sg:GetFirst():GetOriginalCode()
			Duel.Hint(HINT_CARD,0,code)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			c:RegisterEffect(e1)
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(TYPE_GEMINI)
			e2:SetRange(LOCATION_MZONE)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e3:SetCountLimit(1)
			e3:SetCondition(c26063007.flcon)
			e3:SetOperation(c26063007.flop)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			c:RegisterEffect(e3)
			c:EnableGeminiState()
			return true
		end
	end
	return false
end
function c26063007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_GEMINI)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c26063007.tgfilter(c)
	return c:IsMonster() and not c:IsType(TYPE_TOKEN)
end
function c26063007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local loc =LOCATION_MZONE+LOCATION_GRAVE
	if chkc then return chkc:IsLocation(loc) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(c26063007.tgfilter,tp,loc,loc,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26063007.tgfilter,tp,loc,loc,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c26063007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c26063007.flcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c26063007.flop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
end