--Entrophys State of Matter
function c26065012.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26065012,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26065012,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26065012.target)
	e1:SetOperation(c26065012.activate)
	c:RegisterEffect(e1)
end
c26065012.listed_series={0x665,0x1665}
function c26065012.tgfilter(c)
	return c:IsSetCard(0x1665) and c:IsAbleToGrave()
end
function c26065012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26065012.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,99,aux.dncheck,0) and
		Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,1,nil) end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,dg,1,0,0)
end
function c26065012.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26065012.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_MZONE,0,nil)
	local sg=aux.SelectUnselectGroup(g1,e,tp,1,#g1,aux.dncheck,1,tp,HINTMSG_TOGRAVE)
	if #sg>0 and Duel.SendtoGrave(sg,REASON_EFFECT)>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		local tg=g2:Select(1-tp,#sg,#sg,nil)
		local att=0
		local tc=tg:GetFirst()
		for tc in aux.Next(tg) do
			att=(att|tc:GetAttribute())
		end
		Duel.SendtoGrave(tg,REASON_RULE+REASON_RELEASE)
		if not Duel.SelectYesNo(tp,aux.Stringid(26065012,1)) then return end
		Duel.BreakEffect()
		local tkg=Group.CreateGroup()
		local tLIGHT,tDARK,tWIND,tEARTH,tFIRE,tWATER,tGOD=nil
		if att&ATTRIBUTE_LIGHT~=0 then
			tLIGHT=Duel.CreateToken(tp,26065200)
			tkg:AddCard(tLIGHT)
		end  
		if att&ATTRIBUTE_DARK~=0 then
			tDARK=Duel.CreateToken(tp,26065201)
			tkg:AddCard(tDARK)
		end  
		if att&ATTRIBUTE_WIND~=0 then
			tWIND=Duel.CreateToken(tp,26065202)
			tkg:AddCard(tWIND)
		end  
		if att&ATTRIBUTE_EARTH~=0 then
			tEARTH=Duel.CreateToken(tp,26065203)
			tkg:AddCard(tEARTH)
		end  
		if att&ATTRIBUTE_FIRE~=0 then
			tFIRE=Duel.CreateToken(tp,26065204)
			tkg:AddCard(tFIRE)
		end  
		if att&ATTRIBUTE_WATER~=0 then
			tWATER=Duel.CreateToken(tp,26065205)
			tkg:AddCard(tWATER)
		end  
		if att&0x40~=0 then
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