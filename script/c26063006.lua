--Stelloy Commander - Stein
function c26063006.initial_effect(c)
	Xyz.AddProcedure(c,nil,4,2,c26063006.ovfilter,aux.Stringid(26063006,1),7)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMOVE_TYPE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetValue(TYPE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(aux.GeminiNormalCondition)
	c:RegisterEffect(e1)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e0:SetTargetRange(1,0)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c26063006.xcond)
	e0:SetTarget(c26063006.xtg)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--gain effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsGeminiState)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c26063006.stat)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Alum
		--immune to non-target, non-destroy actions
		local e41=Effect.CreateEffect(c)
		e41:SetType(EFFECT_TYPE_SINGLE)
		e41:SetCode(EFFECT_IMMUNE_EFFECT)
		e41:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e41:SetRange(LOCATION_MZONE)
		e41:SetLabel(26063002)
		e41:SetValue(c26063006.protval)
		c:RegisterEffect(e41)
		--Search 2
		local e51=Effect.CreateEffect(c)
		e51:SetDescription(aux.Stringid(26063002,1))
		e51:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
		e51:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e51:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		e51:SetCode(EVENT_SPSUMMON_SUCCESS)
		e51:SetCountLimit(1,26063002)
		e51:SetLabel(26063002)
		e51:SetCondition(c26063006.gcond)
		e51:SetCost(c26063006.gcost)
		e51:SetTarget(c26063006.target2)
		c:RegisterEffect(e51)
		local e51a=e51:Clone()
		e51a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(e51a)
	--Cypra
		--untargetable
		local e42=Effect.CreateEffect(c)
		e42:SetType(EFFECT_TYPE_SINGLE)
		e42:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e42:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e42:SetRange(LOCATION_MZONE)
		e42:SetValue(aux.tgoval)
		e42:SetLabel(26063003)
		e42:SetCondition(c26063006.gcond)
		e42:SetValue(aux.tgoval)
		c:RegisterEffect(e42)
		--search/mill 1
		local e52=Effect.CreateEffect(c)
		e52:SetDescription(aux.Stringid(26063003,1))
		e52:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DRAW)
		e52:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e52:SetProperty(EFFECT_FLAG_DELAY)
		e52:SetCode(EVENT_SPSUMMON_SUCCESS)
		e52:SetCountLimit(1,26063003)
		e52:SetLabel(26063003)
		e52:SetCondition(c26063006.gcond)
		e52:SetCost(c26063006.gcost)
		e52:SetTarget(c26063006.target3)
		c:RegisterEffect(e52)
		local e52a=e52:Clone()
		e52a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(e52a)
	--Ferrix
		--indestructible
		local e43=Effect.CreateEffect(c)
		e43:SetType(EFFECT_TYPE_SINGLE)
		e43:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e43:SetRange(LOCATION_MZONE)
		e43:SetLabel(26063003)
		e43:SetCondition(c26063006.gcond)
		e43:SetValue(1)
		c:RegisterEffect(e43)
		--retrieve 1-2 targets
		local e53=Effect.CreateEffect(c)
		e53:SetDescription(aux.Stringid(26063004,1))
		e53:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
		e53:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e53:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e53:SetCode(EVENT_SPSUMMON_SUCCESS)
		e53:SetLabel(26063004)
		e53:SetCondition(c26063006.gcond)
		e53:SetCost(c26063006.gcost)
		e53:SetCountLimit(1,26063004)
		e53:SetTarget(c26063006.target4)
		c:RegisterEffect(e53)
		local e53a=e53:Clone()
		e53a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(e53a)
	--Niclas
		--unremovable
		local e44=Effect.CreateEffect(c)
		e44:SetType(EFFECT_TYPE_SINGLE)
		e44:SetCode(EFFECT_UNRELEASABLE_SUM)
		e44:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e44:SetRange(LOCATION_MZONE)
		e44:SetLabel(26063005)
		e44:SetCondition(c26063006.gcond)
		e44:SetValue(1)
		c:RegisterEffect(e44)
		local e44a=e44:Clone()
		e44a:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e44a)
		local e44b=Effect.CreateEffect(c)
		e44b:SetType(EFFECT_TYPE_SINGLE)
		e44b:SetCode(EFFECT_CANNOT_REMOVE)
		e44b:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e44b:SetRange(LOCATION_MZONE)
		e44b:SetLabel(26063005)
		e44b:SetTargetRange(1,1)
		e44b:SetCondition(c26063006.gcond)
		e44b:SetTarget(c26063006.rmlimit)
		c:RegisterEffect(e44b)
		--retrieve/revive 1 target
		local e54=Effect.CreateEffect(c)
		e54:SetDescription(aux.Stringid(26063005,1))
		e54:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e54:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e54:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE+CATEGORY_SPECIAL_SUMMON)
		e54:SetCode(EVENT_SPSUMMON_SUCCESS)
		e54:SetCountLimit(1,26063005)
		e54:SetLabel(26063005)
		e54:SetCondition(c26063006.gcond)
		e54:SetCost(c26063006.gcost)
		e54:SetTarget(c26063006.target5)
		c:RegisterEffect(e54)
		local e54a=e54:Clone()
		e54a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(e54a)
	--destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c26063006.reptg)
	c:RegisterEffect(e6)
end
--can be Xyz summoned using only "Stelloy Squire - Carbin" as material
c26063006.listed_names={26063001}
function c26063006.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,26063001)
end
--can be "Gemini Summoned" by attaching one or more extra materials
function c26063006.xmat(c,rk)
	return c:GetLevel()==rk and c:IsCanBeXyzMaterial()
end
function c26063006.xcond(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local rk=c:GetRank()
	return not c:IsGeminiState() and Duel.IsExistingMatchingCard(c26063006.xmat,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,c,rk)
end
function c26063006.xtg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local rk=c:GetRank()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local b=Duel.GetMatchingGroup(c26063006.xmat,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c,rk)
	if #b>0 then
		sg=aux.SelectUnselectGroup(b,e,tp,1,99,c26063006.matcond,1,tp,aux.Stringid(26063006,1),nil,nil,true)
		if #sg>0 then
			Duel.Overlay(c,sg)
			e:GetHandler():EnableGeminiState()
			return true
		end
	end
	return false
end
function c26063006.matcond(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
--Gains the ATK/DEF gain effects
function c26063006.stat(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	local v,v1,v2,v3,v4=0,0,0,0,0
	local gf=g:GetFirst()
	while gf do
	   if Card.GetCode(gf)==26063002 then v1=1 end
	   if Card.GetCode(gf)==26063003 then v2=3 end
	   if Card.GetCode(gf)==26063004 then v3=4 end
	   if Card.GetCode(gf)==26063005 then v4=2 end
	   gf=g:GetNext()
	end
	v=(v1+v2+v3+v4)*100
	return v
end
function c26063006.gcond(e)
	local c=e:GetHandler()
	return c:IsGeminiState() and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,e:GetLabel())
end
function c26063006.rmlimit(e,c,tp,r)
	return c==e:GetHandler() and r==REASON_EFFECT
end
function c26063006.protval(e,te,tp)
	local mat=e:GetLabel()
	local tc=te:GetHandler()
	if mat==26063002 then
		return te:GetOwner()~=e:GetHandler() and te:IsActivated() and not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and not te:IsHasCategory(CATEGORY_DESTROY)
	end
	if mat==26063005 then
		return tp~=e:GetHandler() and te:IsHasType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O) and tc:IsType(TYPE_MONSTER) 
		and tc:IsSetCard(0x663)
	end
end
function c26063006.effilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsSetCard(0x663)
end
function c26063006.gcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(Card.IsCode,nil,e:GetLabel())
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,1,nil)
	local tg=sg:GetFirst():GetCode()
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoGrave(sg,REASON_COST)
end
function c26063006.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rvg=Duel.GetMatchingGroup(c26063002.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return rvg:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	e:SetOperation(c26063002.operation)
end

function c26063006.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26063003.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	e:SetOperation(c26063003.operation)
end
function c26063006.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c26063004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26063004.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26063004.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	e:SetOperation(c26063004.operation)
end
function c26063006.target5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c26063005.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26063005.setfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c26063005.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	e:SetOperation(c26063005.operation)
end
function c26063006.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
