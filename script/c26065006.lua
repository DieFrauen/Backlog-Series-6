--Entrophys Marshall Opus - Yliaster
function c26065006.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x665),4,4)
	--Material check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetLabel(0)
	e0:SetValue(c26065006.matcheck)
	c:RegisterEffect(e0)
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0a:SetCondition(c26065006.attcon)
	e0a:SetOperation(c26065006.attop)
	e0a:SetLabelObject(e0)
	c:RegisterEffect(e0a)
	--use opposing tokens as materials
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c26065006.extracon)
	e1:SetValue(c26065006.extraval)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetLabel(ATTRIBUTE_FIRE)
	e2:SetCondition(c26065006.condition)
	e2:SetValue(c26065006.val)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetLabel(ATTRIBUTE_EARTH)
	e3:SetCondition(c26065006.condition)
	e3:SetValue(c26065006.efilter)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26065006,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E+TIMING_MAIN_END)
	e4:SetCountLimit(1)
	e4:SetLabel(ATTRIBUTE_WIND)
	e4:SetCondition(c26065006.condition)
	e4:SetCost(c26065006.thcost)
	e4:SetTarget(c26065006.thtg)
	e4:SetOperation(c26065006.thop)
	c:RegisterEffect(e4)
	--Spirit monster do not have to return to the hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetLabel(ATTRIBUTE_DARK)
	e5:SetCondition(c26065006.condition)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PREDRAW)
	e6:SetRange(LOCATION_MZONE)
	e6:SetLabel(ATTRIBUTE_DARK+ATTRIBUTE_WIND+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE)
	e6:SetCondition(c26065006.condition)
	e6:SetOperation(c26065006.search)
	c:RegisterEffect(e6)
end
function c26065006.mfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x665,lc,sumtype,tp)
end
function c26065006.matcheck(e,c)
	local g=c:GetMaterial()
	local sg=g:Filter(Card.IsSetCard,nil,0x2665)
	local att=0
	if sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0 then
		att=att+ATTRIBUTE_EARTH 
	end
	if sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>0 then
		att=att+ATTRIBUTE_WATER 
	end
	if sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WIND)>0 then
		att=att+ATTRIBUTE_WIND 
	end
	if sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0 then
		att=att+ATTRIBUTE_FIRE 
	end
	if sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0 then
		att=att+ATTRIBUTE_LIGHT 
	end
	if sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0 then
		att=att+ATTRIBUTE_DARK 
	end
	if sg:FilterCount(Card.IsAttribute,nil,0x40)>0 then
		att=att+0x40
	end
	e:SetLabel(att)
end

function c26065006.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c26065006.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local att=e:GetLabelObject():GetLabel()
	if att>0 then
		--add attributes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(att|c:GetAttribute())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c26065006.addcon(e,tp,eg,ep,ev,re,r,rp)
	local lb=e:GetLabelObject():GetLabel()
	if lb>0 then
		e:SetLabel(lb)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
	end
	e:SetLabel(0)
end
function c26065006.condition(e,tp,eg,ep,ev,re,r,rp)
	local lb=e:GetLabel()
	local ct=e:GetHandler():GetAttribute()
	return ct&lb==lb
end
function c26065006.attfilter(c)
	return c:IsSetCard(0x665) and c:IsFaceup()
end
function c26065006.val(e,c)
	local ct=Duel.GetMatchingGroup(c26065006.attfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil):GetBinClassCount(Card.GetAttribute)
	return ct*250
end
function c26065006.efilter(e,te)
	return te:GetHandler():IsSetCard(0x665) and te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c26065006.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x665,lc,sumtype,tp)
end
function c26065006.pub(c)
	return not c:IsPublic()
end
function c26065006.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsControler,1,nil,tp)
	and sg:IsExists(Card.IsControler,1,nil,1-tp)
	and not sg:IsExists(c26065006.pub,1,nil)
	and (#sg:Filter(Card.IsType,nil,TYPE_MONSTER)==2
	  or #sg:Filter(Card.IsType,nil,TYPE_SPELL)==2
	  or #sg:Filter(Card.IsType,nil,TYPE_TRAP)==2)
end
function c26065006.tcost(c)
	return c:IsSetCard(0x665) and c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function c26065006.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26065006.tcost,tp,LOCATION_MZONE,LOCATION_MZONE,nil):Filter(Card.IsReleasable,nil)
	if chk==0 then return #g>0 end
	local sg=g:Select(tp,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c26065006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return aux.SelectUnselectGroup(rg,e,tp,2,2,c26065006.rescon,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,rg,2,0,0)
end
function c26065006.thop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,c26065006.rescon,1,tp,HINTMSG_ATOHAND)
	if #g==2 then
		Duel.HintSelection(g,true)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c26065006.search(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetDrawCount(tp)
	if Duel.GetTurnPlayer()~=tp then return end
	if dt~=0 and Duel.SelectYesNo(tp,aux.Stringid(26065006,1)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Hint(HINT_CARD,tp,26065006)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
c26065006.curgroup=nil
function c26065006.extracon(c,e,tp,sg,mg,lc,og,chk)
	return not c26065006.curgroup or #(sg&c26065006.curgroup)<5
end
function c26065006.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			c26065006.curgroup=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_TOKEN)
			c26065006.curgroup:KeepAlive()
			return c26065006.curgroup
		end
	elseif chk==2 then
		if c26065006.curgroup then
			c26065006.curgroup:DeleteGroup()
		end
		c26065006.curgroup=nil
	end
end