--Astelloy Arbiter - Alum
function c26063002.initial_effect(c)
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
	e0a:SetCondition(c26063002.gemini)
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
	e1:SetValue(100)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Gemini.EffectStatusCondition)
	e3:SetValue(c26063002.protval)
	c:RegisterEffect(e3)
	--normal summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26063002,0))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c26063002.gtg)
	e4:SetOperation(c26063002.gop)
	c:RegisterEffect(e4)
	--summon eff
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26063002,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,26063002)
	e5:SetCondition(Gemini.EffectStatusCondition)
	e5:SetTarget(c26063002.target)
	e5:SetOperation(c26063002.operation)
	c:RegisterEffect(e5)
	local e5a=e5:Clone()
	e5a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5a)
	local e5b=e5:Clone()
	e5b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5b)
end
function c26063002.gxys(e)
	local c=e:GetHandler()
	return Gemini.NormalStatusCondition(e) and c:IsHasEffect(26063007)
end
function c26063002.protval(e,te)
	local tc=te:GetHandler()
	return te:GetOwner()~=e:GetHandler() and te:IsActivated() and not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and not te:IsHasCategory(CATEGORY_DESTROY)
end
function c26063002.gemini(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND) or Gemini.NormalStatusCondition(e) 
end
function c26063002.gfilter(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_NORMAL)
end
function c26063002.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26063002.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26063002.gop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26063002.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c26063002.thfilter(c)
	return c:IsType(TYPE_GEMINI) and not c:IsCode(26063002) and c:IsAbleToHand() and c:IsAbleToGrave()
end
function c26063002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26063005.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26063002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rvg=Duel.GetMatchingGroup(c26063002.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local rg=aux.SelectUnselectGroup(rvg,e,tp,2,2,aux.dncheck,1,tp,aux.Stringid(26063002,2))
	Duel.ConfirmCards(1-tp,rg)
	if #rg<2 then return end
	local sg=rg:Select(1-tp,1,1,nil,aux.Stringid(26063002,3))
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	rg:Sub(sg)
	Duel.SendtoGrave(rg,REASON_EFFECT)
end