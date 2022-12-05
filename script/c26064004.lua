--Synodic Over-wind Ruler - Lustrum
function c26064004.initial_effect(c)
	c:EnableReviveLimit()
--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c26064004.fliptg)
	e1:SetOperation(c26064004.flipop)
	c:RegisterEffect(e1)
--flip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c26064004.flip)
	c:RegisterEffect(e2)
--when drawn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064004,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DRAW)
	e3:SetCost(c26064004.drcost)
	e3:SetTarget(c26064004.drtg)
	e3:SetOperation(c26064004.drop)
	c:RegisterEffect(e3)
--leave field
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c26064004.setcon1)
	e4:SetTarget(c26064004.settg)
	e4:SetOperation(c26064004.setop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c26064004.setcon2)
	c:RegisterEffect(e5)
end
function c26064004.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c26064004.flip(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():RegisterFlagEffect(26064001,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26064004.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26064004.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gp=Duel.GetTurnPlayer()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if (gp~=tp and Duel.SelectYesNo(tp,aux.Stringid(26064004,1))) or (Duel.SelectYesNo(tp,aux.Stringid(26064004,1)) and Duel.SelectYesNo(tp,aux.Stringid(26064004,2))) then 
		if Duel.GetCurrentPhase()==PHASE_MAIN1 then
			Duel.SkipPhase(gp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) return
		elseif Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE then
			Duel.SkipPhase(gp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1,1) return
		elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then
			Duel.SkipPhase(gp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1) return
		end
	end
end
function c26064004.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26064004.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064004.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064004.filter(c,e,sp)
	return c:IsCode(26064006) and c:IsAbleToHand()
end
function c26064004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26064004.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	if e:GetHandler():GetFlagEffect(26064004)~=0 then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c26064004.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26064004.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26064004.setfilter(c)
	return c:IsSSetable() or (
	c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true))
end
function c26064004.rescon(sg,e,tp,mg)
	return Duel.IsPlayerCanDraw(tp,#sg)
	and ((sg:FilterCount(Card.IsType,nil,TYPE_MONSTER)==#sg
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>=#sg)
	or   (sg:FilterCount(Card.IsSSetable,nil)==#sg
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>=#sg))
end
function c26064004.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c26064004.ssetfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 or chk==2 then return aux.SelectUnselectGroup(g,e,tp,1,3,c26064004.rescon,0) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26064004.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26064004.ssetfilter,tp,LOCATION_HAND,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,99,c26064004.rescon,1,tp,HINTMSG_SET,c26064004.rescon)
	local drw=0
	if not sg then return end
	if #sg==#sg:Filter(Card.IsSSetable,nil) then
		drw=Duel.SSet(tp,sg,tp,false)
	elseif #sg==#sg:Filter(Card.IsType,nil,TYPE_MONSTER) then
		local spsg=Group.CreateGroup()
		for ec in aux.Next(sg) do
			Duel.SpecialSummonStep(ec,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEDOWN_DEFENSE)
			spsg:AddCard(ec)
		end
		Duel.ConfirmCards(1-tp,spsg)
		Duel.ShuffleSetCard(spsg)
		Duel.SpecialSummonComplete()
		drw=#spsg
	end
	if drw==0 then return end
	Duel.Hint(HINT_CARD,0,26064004)
	Duel.Draw(tp,drw,REASON_EFFECT)
end