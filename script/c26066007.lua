--Hades, Siphantheon of Shadows
function c26066007.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(c26066007.cfilter)
	e2:SetValue(POS_FACEUP)
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2a:SetRange(LOCATION_FZONE)
	e2a:SetTargetRange(LOCATION_HAND,0)
	e2a:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
	e2a:SetLabelObject(e2)
	c:RegisterEffect(e2a)
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_FIELD)
	e2b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2b:SetCode(26066007)
	e2b:SetRange(LOCATION_FZONE)
	e2b:SetTargetRange(1,0)
	c:RegisterEffect(e2b)
	--negate copies from cards in GY
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(c26066007.discon)
	e3:SetOperation(c26066007.disop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e4:SetDescription(aux.Stringid(26066003,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	--e4:SetCondition(c26066007.trcon)
	e4:SetTarget(c26066007.trtg)
	e4:SetOperation(c26066007.trop)
	c:RegisterEffect(e4)
end
function c26066007.trfilter(c,tid)
	return c:GetTurnID()==tid and c:IsLocation(LOCATION_GRAVE) and (c:GetReason()&REASON_RELEASE)~=0
end
function c26066007.trtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c26066007.trfilter(chkc,tid) end
	if chk==0 then return Duel.IsExistingTarget(c26066007.trfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26066007.trfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil,tid)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,1,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26066007.thfilter(c,eg)
	local mg=eg:FilterCount(Card.IsMonster,nil)
	local sg=eg:FilterCount(Card.IsSpell  ,nil)
	local tg=eg:FilterCount(Card.IsTrap   ,nil)
	local b1=mg>1 or (sg>0 and tg>0)
	local b2=sg>1 or (mg>0 and tg>0)
	local b3=tg>1 or (sg>0 and mg>0)
	return c:IsSetCard(0x666) and c:IsAbleToHand() and 
	((c:IsMonster() and b1) or
	(c:IsSpell() and b2) or
	(c:IsTrap() and b3))
end
function c26066007.trop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg then
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26066007.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,sg)
		mg:Sub(sg)
		if #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(26066007,0)) then
			local ec=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(ec,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,ec)
		else
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c26066007.cfilter(e,c)
	return c:IsMonster() and e:GetHandler()~=c 
end
function c26066007.code(c,lab,code1,code2)
	return c:IsCode(code1,code2) and c:GetFlagEffect(26066007)~=0
end
function c26066007.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return (rc:GetFlagEffect(26066007)~=0 or Duel.IsExistingMatchingCard(c26066007.code,tp,0,LOCATION_GRAVE,1,nil,true,code1,code2)) and not rc:IsSetCard(0x666) and code2~=26066006
end
function c26066007.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26066007)
	Duel.NegateEffect(ev)
end
