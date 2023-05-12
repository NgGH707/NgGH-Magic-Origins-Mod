this.perk_nggh_bdsm_dommy_mommy <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bdsm_dommy_mommy";
		this.m.Name = ::Const.Strings.PerkName.NggH_BDSM_DommyMommy;
		this.m.Description = ::Const.Strings.PerkDescription.NggH_BDSM_DommyMommy;
		this.m.Icon = "ui/perks/perk_bdsm_dommy_mommy.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

 	function onAdded()
 	{
 		if (!this.m.IsNew) return;
 		
 		::World.Assets.getOrigin().addScenarioPerk(this.getContainer().getActor().getBackground(), ::Const.Perks.PerkDefs.Fearsome, 5);
		this.m.IsNew = false;
 	}

 	function onRemoved()
 	{
 		this.getContainer().getActor().getBackground().removePerk(::Const.Perks.PerkDefs.Fearsome);
 		this.getContainer().removeByID(::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.Fearsome].ID);
 	}

});

