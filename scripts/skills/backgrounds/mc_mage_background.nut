this.mc_mage_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Job = this.Const.MC_Job.None,
		Tier = this.Const.MC_MagicTier.Basic,
		AdditionalPerkGroup = []
	},
	function create()
	{
		this.character_background.create();
	}

	function onAdded()
	{
		foreach ( script in this.Const.MC_Magic[this.m.Job][this.m.Tier] ) 
		{
		    this.getContainer().add(this.new("scripts/skills/" + script));
		}

		this.character_background.onAdded();
		this.getContainer().getActor().getFlags().set("mc_mage", this.m.Job);
		this.getContainer().add(this.new("scripts/skills/mc_actives/mc_concentrate"));
		this.getContainer().removeByID("actives.hand_to_hand");
		this.getContainer().add(this.new("scripts/skills/mc_actives/mc_hand_to_hand"));
	}	

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.Const.World.Common.pickHelmet([
			[
				1,
				"legend_seer_hat"
			],
			[
				1,
				"magician_hat"
			]
		]));
		items.equip(this.Const.World.Common.pickArmor([
			[
				1,
				"legend_seer_robes"
			]
		]));
		items.equip(this.new("scripts/items/weapons/legend_mystic_staff"));
	}

	function buildPerkTree()
	{
		local ret = this.character_background.buildPerkTree();

		if (this.m.PerkTree != null)
		{
			this.addPerkGroup(this.Const.Perks.MC_MagicTree.Tree);

			foreach ( group in this.m.AdditionalPerkGroup ) 
			{
			    this.addPerkGroup(group);
			}
		}

		return ret;
	}
	
});

