::mods_hookExactClass("skills/effects/ptr_swordmaster_scenario_recruit_effect", function ( obj )
{
	local ws_evolve = obj.evolve;
	obj.evolve = function()
	{
		local actor = this.getContainer().getActor();

		if (!actor.getFlags().has("human"))
		{
			local attributes = {
				MeleeSkill = ::Math.rand(1, 5),
				MeleeDefense = ::Math.rand(1, 5),
				Stamina = ::Math.rand(1, 5),		
				Bravery = ::Math.rand(5, 10),
				Initiative = ::Math.rand(5, 10)
			};

			actor.getBaseProperties().MeleeSkill += attributes.MeleeSkill;
			actor.getBaseProperties().MeleeDefense += attributes.MeleeDefense;
			actor.getBaseProperties().Stamina += attributes.Stamina;
			actor.getBaseProperties().Bravery += attributes.Bravery;
			actor.getBaseProperties().Initiative += attributes.Initiative;
			return attributes;
		}

		return ws_evolve();
	};
});