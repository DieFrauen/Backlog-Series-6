--Entrophys State of Matter
function c26065012.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26065012,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26065012,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26065012.target)
	e1:SetOperation(c26065012.activate)
	c:RegisterEffect(e1)
	--activate effect from graveyard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26065012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c26065012.tkcost)
	e2:SetTarget(c26065012.tktg)
	e2:SetOperation(c26065012.tkop)
	c:RegisterEffect(e2)
end
c26065012.listed_series={0x665,0x1665}
function c26065012.tgfilter(c)
	return c:IsSetCard(0x1665) and c:IsAbleToGrave()
end
function c26065012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c26065012.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c26065012.tgfilter,tp,0,LOCATION_ONFIELD,nil)
	local tc=g2:GetFirst()
	if chk==0 then return aux.SelectUnselectGroup(g1,e,tp,1,99,aux.dncheck,0) and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,1,nil) end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,dg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c26065012.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26065012.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local sg=aux.SelectUnselectGroup(g1,e,tp,1,#g1,aux.dncheck,1,tp,HINTMSG_TOGRAVE)
	if #sg>0 and Duel.SendtoGrave(sg,REASON_EFFECT)>0 and #g2>0 then
		local tc=g2:GetFirst()
		local attr=0
		for tc in aux.Next(g2) do
			attr=(attr|tc:GetAttribute())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local arc=Duel.AnnounceAttribute(1-tp,#sg,attr)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		g2=g2:Filter(Card.IsAttribute,nil,arc)
		Duel.SendtoGrave(g2,REASON_RULE+REASON_RELEASE)
		Duel.BreakEffect()
		local tkg=Group.CreateGroup()
		local tLIGHT,tDARK,tWIND,tEARTH,tFIRE,tWATER,tGOD=nil
		if arc&ATTRIBUTE_LIGHT~=0 then
			tLIGHT=Duel.CreateToken(tp,26065200)
			tkg:AddCard(tLIGHT)
		end  
		if arc&ATTRIBUTE_DARK~=0 then
			tDARK=Duel.CreateToken(tp,26065201)
			tkg:AddCard(tDARK)
		end  
		if arc&ATTRIBUTE_WIND~=0 then
			tWIND=Duel.CreateToken(tp,26065202)
			tkg:AddCard(tWIND)
		end  
		if arc&ATTRIBUTE_EARTH~=0 then
			tEARTH=Duel.CreateToken(tp,26065203)
			tkg:AddCard(tEARTH)
		end  
		if arc&ATTRIBUTE_FIRE~=0 then
			tFIRE=Duel.CreateToken(tp,26065204)
			tkg:AddCard(tFIRE)
		end  
		if arc&ATTRIBUTE_WATER~=0 then
			tWATER=Duel.CreateToken(tp,26065205)
			tkg:AddCard(tWATER)
		end  
		if arc&0x40~=0 then
			tGOD=Duel.CreateToken(tp,26065206)
			tkg:AddCard(tGOD)
		end
		local mx=#tkg
		local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ft<mx then mx=ft end
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then mx=1 end
		local tkc=tkg:Select(tp,1,mx,nil)
		Duel.SpecialSummon(tkc,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c26065012.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end

function c26065012.tkfilter(c,tp)
	return c:IsSetCard(0x665) and Duel.IsPlayerCanSpecialSummonMonster(tp,26065101,0,TYPES_TOKEN+TYPE_SPIRIT,0,0,1,RACE_AQUA,c:GetAttribute(),nil,1-tp)
end
function c26065012.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c26065012.tkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26065012.tkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c26065012.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c26065012.tkfilter(tc,tp) then
	local att=tc:GetAttribute()
	code=26065206
	if   att|ATTRIBUTE_LIGHT ==ATTRIBUTE_LIGHT then
		code=26065200
	elseif att|ATTRIBUTE_DARK  ==ATTRIBUTE_DARK  then
		code=26065201
	elseif att|ATTRIBUTE_WIND  ==ATTRIBUTE_WIND  then
		code=26065202
	elseif att|ATTRIBUTE_EARTH ==ATTRIBUTE_EARTH then
		code=26065203
	elseif att|ATTRIBUTE_FIRE  ==ATTRIBUTE_FIRE  then
		code=26065204
	elseif att|ATTRIBUTE_WATER ==ATTRIBUTE_WATER then
		code=26065205
	end
	local token=Duel.CreateToken(tp,code)
	Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SpecialSummonComplete()
	end
end