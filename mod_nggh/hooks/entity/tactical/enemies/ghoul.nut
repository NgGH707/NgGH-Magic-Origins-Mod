::mods_hookExactClass("entity/tactical/enemies/ghoul", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Flags.add("ghoul");
	}

	obj.onAfterDeath = function(_tile)
	{
		if (this.m.Size < 3)
		{
			return;
		}

		local skill;
		foreach (id in [
			"actives.swallow_whole",
			"actives.legend_skin_ghoul_swallow_whole"
		])
		{
			skill = this.getSkills().getSkillByID(id)

			if (skill != null)
			{
				break;
			}
		}

		if (skill == null)
		{
			return;
		}

		if (skill.getSwallowedEntity() == null)
		{
			return;
		}

		if (::Tactical.Entities.isCombatFinished())
		{
			return;
		}

		local e = skill.getSwallowedEntity();
		::Tactical.addEntityToMap(e, _tile.Coords.X, _tile.Coords.Y);
		e.getFlags().set("Devoured", false);

		if (!e.isPlayerControlled() && e.getType() != ::Const.EntityType.Serpent)
		{
			::Tactical.getTemporaryRoster().remove(e);
		}

		::Tactical.TurnSequenceBar.addEntity(e);

		if (e.hasSprite("dirt"))
		{
			local slime = e.getSprite("dirt");
			slime.setBrush("bust_slime");
			slime.Visible = true;
		}
	}

	local onInit = obj.onInit;
	obj.onInit = function()
	{
		onInit();
		local chance = 25;

		if (("Assets" in ::World) && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			chance = 100;
		}

		if (!::Tactical.State.isScenarioMode() && ::World.getTime().Days >= 125)
		{
			chance = ::Math.min(100, chance + ::Math.max(10, ::World.getTime().Days - 200));
		}

		::Nggh_MagicConcept.HooksHelper.randomlyRollPerk(this, [::Const.Perks.PerkDefs.NggHNacho, ::Const.Perks.PerkDefs.NggHNachoEat, ::Const.Perks.PerkDefs.NggHNachoFrenzy, ::Const.Perks.PerkDefs.NggHNachoBigTummy], chance);
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		local b = this.m.BaseProperties;
		b.MeleeSkill += 10;
		b.MeleeDefense += 10;
		b.RangedDefense += 5;
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_nacho"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nggh_nacho_frenzy"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_devastating_strikes"));
		this.m.Skills.add(::new("scripts/skills/actives/charge"));
		return true;
	}
});