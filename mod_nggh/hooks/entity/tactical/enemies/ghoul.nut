::Nggh_MagicConcept.HooksMod.hook("scripts/entity/tactical/enemies/ghoul", function(q) 
{
	q.create = @(__original) function()
	{
		__original();
		m.Flags.add("ghoul");
	}

	q.onAfterDeath = function(_tile)
	{
		if (m.Size < 3)
			return;

		local skill;

		foreach (id in [
			"actives.swallow_whole",
			"actives.legend_skin_ghoul_swallow_whole"
		])
		{
			skill = getSkills().getSkillByID(id)

			if (skill != null)
				break;
		}

		if (skill == null)
			return;

		if (::MSU.isNull(skill.getSwallowedEntity()))
			return;

		if (::Tactical.Entities.isCombatFinished())
			return;

		local e = skill.getSwallowedEntity();
		::Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
		e.getFlags().set("Devoured", false);

		if (e.getType() != ::Const.EntityType.Serpent)
			::Tactical.getTemporaryRoster().remove(e);

		::Tactical.TurnSequenceBar.addEntity(e);

		if (e.hasSprite("dirt")) {
			local slime = e.getSprite("dirt");
			slime.setBrush("bust_slime");
			slime.Visible = true;
		}

		skill.m.SwallowedEntity = null;
	}

	q.onInit = @(__original) function()
	{
		__original();
		local chance = 15;

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
			chance = 100;

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 125)
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 200));

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHNacho, ::Const.Perks.PerkDefs.NggHNachoEat, ::Const.Perks.PerkDefs.NggHNachoFrenzy, ::Const.Perks.PerkDefs.NggHNachoBigTummy], chance);
	}

	q.makeMiniboss <- function()
	{
		if (!actor.makeMiniboss())
			return false;

		local b = m.BaseProperties;
		b.MeleeSkill += 5;
		b.MeleeDefense += 5;
		b.DamageRegularMax += 5;
		getSkills().add(::new("scripts/skills/perks/perk_nggh_nacho"));
		getSkills().add(::new("scripts/skills/perks/perk_nggh_nacho_frenzy"));
		getSkills().add(::new("scripts/skills/perks/perk_sundering_strikes"));
		getSkills().add(::new("scripts/skills/actives/charge"));

		if (!::Tactical.State.isScenarioMode()) {
			if (::World.getTime().Days >= 100)
				getSkills().add(::new("scripts/skills/perks/perk_fearsome"));

			if (::World.getTime().Days >= 200)
				getSkills().add(::new("scripts/skills/perks/perk_nimble"));
		}

		return true;
	}
});