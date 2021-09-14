this.getroottable().HexenHooks.hookContracts <- function ()
{
	::mods_hookNewObject("contracts/contracts/legend_hunting_skin_ghouls_contract", function ( obj )
	{
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_ghoul") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}

				if (!bro.getSkills().hasSkill(this.m.Perk))
				{
					continue;
				}

				local stats = this.Const.LegendMod.GetFavoriteEnemyStats(bro, this.m.ValidTypes);

				if (stats.Strength >= this.m.MinStrength)
				{
					return true;
				}
			}

			return false;
		}
	});
	::mods_hookNewObject("contracts/contracts/legend_hunting_stollwurms_contract", function ( obj )
	{
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_lindwurm") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}

				if (!bro.getSkills().hasSkill(this.m.Perk))
				{
					continue;
				}

				local stats = this.Const.LegendMod.GetFavoriteEnemyStats(bro, this.m.ValidTypes);

				if (stats.Strength >= this.m.MinStrength)
				{
					return true;
				}
			}

			return false;
		}
	});
	::mods_hookNewObject("contracts/contracts/legend_hunting_white_direwolf_contract", function ( obj )
	{
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_direwolf") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}

				if (!bro.getSkills().hasSkill(this.m.Perk))
				{
					continue;
				}

				local stats = this.Const.LegendMod.GetFavoriteEnemyStats(bro, this.m.ValidTypes);

				if (stats.Strength >= this.m.MinStrength)
				{
					return true;
				}
			}

			return false;
		}
	});
	::mods_hookNewObject("contracts/contracts/legend_hunting_rock_unholds_contract", function ( obj )
	{
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_unhold") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}

				if (!bro.getSkills().hasSkill(this.m.Perk))
				{
					continue;
				}

				local stats = this.Const.LegendMod.GetFavoriteEnemyStats(bro, this.m.ValidTypes);

				if (stats.Strength >= this.m.MinStrength)
				{
					return true;
				}
			}

			return false;
		}
	});
	::mods_hookNewObject("contracts/contracts/legend_hunting_redback_webknechts_contract", function ( obj )
	{
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_spider") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}

				if (!bro.getSkills().hasSkill(this.m.Perk))
				{
					continue;
				}

				local stats = this.Const.LegendMod.GetFavoriteEnemyStats(bro, this.m.ValidTypes);

				if (stats.Strength >= this.m.MinStrength)
				{
					return true;
				}
			}

			return false;
		}
	});
	::mods_hookNewObject("contracts/contracts/legend_hunting_greenwood_schrats_contract", function ( obj )
	{
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_schrat") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}

				if (!bro.getSkills().hasSkill(this.m.Perk))
				{
					continue;
				}

				local stats = this.Const.LegendMod.GetFavoriteEnemyStats(bro, this.m.ValidTypes);

				if (stats.Strength >= this.m.MinStrength)
				{
					return true;
				}
			}

			return false;
		}
	});
	::mods_hookNewObject("contracts/contracts/legend_hunting_demon_alps_contract", function ( obj )
	{
		obj.onIsValid = function()
		{
			foreach( bro in this.World.getPlayerRoster().getAll() )
			{
				if (bro.getSkills().hasSkill("perk.charm_enemy_alps") && bro.getSkills().hasSkill("perk.mastery_charm"))
				{
					return true;
				}

				if (!bro.getSkills().hasSkill(this.m.Perk))
				{
					continue;
				}

				local stats = this.Const.LegendMod.GetFavoriteEnemyStats(bro, this.m.ValidTypes);

				if (stats.Strength >= this.m.MinStrength)
				{
					return true;
				}
			}

			return false;
		}
	});

	delete this.HexenHooks.hookContracts;
}