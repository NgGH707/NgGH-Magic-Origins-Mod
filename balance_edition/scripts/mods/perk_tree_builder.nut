this.perk_tree_builder <- {
	m = {
		NimbleChance = 33,
		MuscularityChance = 25,
		BattleHeartChance = 5,
	},
	
	function fillWithRandomPerk( _tree , _skillsContainer , _addWeaponPerks = false , _hasAoE = false , _isSpecial = false, _removeNimble = false )
	{
		local currentPerksPerkRow = [];
		local excludedPerks = [];

		foreach ( _row in _tree )
		{
			foreach ( _perkDef in _row )
			{
				excludedPerks.push(_perkDef);
			}

			currentPerksPerkRow.push(_row.len());
		}

		local maxPerksPerRow = [8, 7, 6, 9, 6, 6, 5, 0, 0, 0, 0, 0, 0, 0];
		local tools = {};
		tools.hasPerk <- function( _perk , _excluded )
		{
			return _excluded.find(_perk) != null;
		};
		tools.isInTree <- function( _tree, _perk )
		{
			foreach( row in _tree )
			{
				if (row.find(_perk) != null)
				{
					return true;
				}
			}

			return false;
		};
		tools.removePerk <- function( _lib , _perk )
		{
			foreach ( _l in _lib )
			{
				local index = _l.find(_perk);

				if (index != null)
				{
					return _l.remove(index);
				}
			}
		}
		tools.removeExistingPerks <- function( _lib , _excluded )
		{
			foreach ( library in _lib ) 
			{
			    foreach ( _perk in _excluded )
			    {
			    	while (library.find(_perk) != null)
			    	{
			    		local index = library.find(_perk);
			    		library.remove(index);
			    	}
			    }
			}
		}
	
		local lib = this.getLib();
		local libE = this.getEnemyLib();

		if (::mods_getRegisteredMod("mod_legends_PTR") != null)
		{
			for ( local i = 0; i < 6; i = ++i ) 
			{
			    maxPerksPerRow[i] += 1;
			}
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			lib[0].extend(libE[0]);
			maxPerksPerRow[this.Math.rand(0, 6)] += 1;
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			lib[1].extend(libE[1]);
			maxPerksPerRow[this.Math.rand(0, 6)] += 1;
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			lib[2].extend(libE[2]);
		}
		
		this.addPTR_Perks(lib, _skillsContainer, _isSpecial, _hasAoE);
		tools.removeExistingPerks(lib, excludedPerks);
		
		for ( local i = 0 ; i < 20 ; i = i ) 
		{
		    foreach (j, row in _tree ) 
		    {
		        if (row.len() >= maxPerksPerRow[j])
		        {
		        	continue;
		        }

		        local lib_to_choose = [];

		        if (j <= 2)
		        {
		        	lib_to_choose.extend(lib[0]);
		        }
		        else if (j == 3) 
		        {
		            lib_to_choose.extend(lib[0]);
		            lib_to_choose.extend(lib[1]);
		        }
		        else if (j == 4) 
		        {
		            lib_to_choose.extend(lib[1]);
		        }
		        else if (j == 5) 
		        {
		            lib_to_choose.extend(lib[1]);
		            lib_to_choose.extend(lib[2]);
		        }
		        else if (j == 6) 
		        {
		            lib_to_choose.extend(lib[2]);
		        }

		        if (lib_to_choose.len() == 0)
		        {
		        	continue;
		        }

		        local r;
		        do
		        {
		        	if (r != null)
		        	{
		        		local index = lib_to_choose.find(r);

						if (index != null)
						{
							lib_to_choose.remove(index);
						}
		        	}

		        	if (lib_to_choose.len() == 0)
		        	{
		        		r = null;
		        		break;
		        	}

		        	r = lib_to_choose[this.Math.rand(0, lib_to_choose.len() - 1)];
		        }
		        while(tools.hasPerk(r , excludedPerks) && lib_to_choose.len() > 0)

		        if (r != null)
		        {
		        	excludedPerks.push(r);
		        	row.push(r);
		        }
		    }

		    i = ++i;
		}

		if (!_removeNimble && !tools.hasPerk(this.Const.Perks.PerkDefs.Nimble , excludedPerks) && this.Math.rand(1, 100) <= this.m.NimbleChance)
		{
			excludedPerks.push(this.Const.Perks.PerkDefs.Nimble);
			_tree[5].insert(0, this.Const.Perks.PerkDefs.Nimble);
		}

		if (!tools.hasPerk(this.Const.Perks.PerkDefs.LegendMuscularity , excludedPerks) && this.Math.rand(1, 100) <= this.m.MuscularityChance)
		{
			excludedPerks.push(this.Const.Perks.PerkDefs.LegendMuscularity);
			_tree[6].insert(0, this.Const.Perks.PerkDefs.LegendMuscularity);
		}

		if (!tools.hasPerk(this.Const.Perks.PerkDefs.LegendBattleheart , excludedPerks) && this.Math.rand(1, 100) <= this.m.BattleHeartChance)
		{
			excludedPerks.push(this.Const.Perks.PerkDefs.LegendBattleheart);
			_tree[6].insert(0, this.Const.Perks.PerkDefs.LegendBattleheart);
		}

		if (_addWeaponPerks)
		{
			local Map = [];
			local excluded = [];
			local addRangedPerks = this.Math.rand(1, 100) <= 50;
			local num = 2 + (addRangedPerks ? 1 : 0);
			
			for ( local i = 0 ; i < num ; i = i )
			{
				local t = this.Const.Perks.MeleeWeaponTrees.getRandom(excluded);

				if (excluded.find(t.ID) == null)
				{
					excluded.push(t.ID);
					Map.push(t.Tree);
					i = ++i;
				}
			}

			if (addRangedPerks)
			{
				for ( local i = 0 ; i < 2 ; i = i )
				{
					local t = this.Const.Perks.RangedWeaponTrees.getRandom(excluded);

					if (excluded.find(t.ID) == null)
					{
						excluded.push(t.ID);
						Map.push(t.Tree);
						i = ++i;
					}
				}
			}
			else 
			{
			    Map.push(this.Const.Perks.ShieldTree.Tree);
			}
			
			foreach (i, tree in Map )
			{
				foreach (j, row in tree ) 
				{
				    foreach (k, perk in row )
				    {
				    	if (tools.hasPerk(perk, excludedPerks))
						{
							continue;
						}

						excludedPerks.push(perk);
				    	_tree[j].push(perk);
				    }
				}
			}
		}
		
		return _tree;
	}

	function getPerksForDamageType( _lib, _damageType = null )
	{
		if (_damageType == null || _damageType.len() == 0)
		{
			return;
		}

		foreach ( damage in _damageType )
		{
			switch (damage.Type) 
			{
			case this.Const.Damage.DamageType.Blunt:
				_lib[0].extend([
					this.Const.Perks.PerkDefs.PTRRattle,
					this.Const.Perks.PerkDefs.PTRDeepImpact,
				]);
				_lib[1].extend([
					this.Const.Perks.PerkDefs.PTRSoftMetal,
					this.Const.Perks.PerkDefs.PTRDismantle,
					this.Const.Perks.PerkDefs.PTRBearDown,
				]);
				_lib[2].extend([
					this.Const.Perks.PerkDefs.PTRDentArmor,
					this.Const.Perks.PerkDefs.PTRHeavyStrikes,
					this.Const.Perks.PerkDefs.PTRBoneBreaker,
				]);
				break;

			case this.Const.Damage.DamageType.Piercing:
				_lib[0].extend([
					this.Const.Perks.PerkDefs.PTRBetweenTheRibs,
					this.Const.Perks.PerkDefs.PTRPointyEnd,
				]);
				_lib[1].extend([
					this.Const.Perks.PerkDefs.PTRThroughTheGaps,
				]);
				break;

			case this.Const.Damage.DamageType.Cutting:
				_lib[0].extend([
					this.Const.Perks.PerkDefs.PTRDismemberment,
					this.Const.Perks.PerkDefs.PTRBetweenTheEyes,
					this.Const.Perks.PerkDefs.PTRVersatileWeapon,
				]);
				_lib[1].extend([
					this.Const.Perks.PerkDefs.PTRDeepCuts,
					this.Const.Perks.PerkDefs.PTRSanguinary,
					this.Const.Perks.PerkDefs.PTRCull,
				]);
				_lib[2].extend([
					this.Const.Perks.PerkDefs.PTRBloodlust,
					this.Const.Perks.PerkDefs.PTRBloodbath,
					this.Const.Perks.PerkDefs.PTRMauler,
				]);
				break;

			case this.Const.Damage.DamageType.Burning:
				break;
			}
		}
	}

	function addPTR_Perks( _lib , _skillsContainer , _isSpecial , _hasAoE = false )
	{
		if (::mods_getRegisteredMod("mod_legends_PTR") == null)
		{
			return;
		}

		_lib[0].extend([
			this.Const.Perks.PerkDefs.PTRSmallTarget,
			this.Const.Perks.PerkDefs.PTRHeadSmasher,
			this.Const.Perks.PerkDefs.PTRFromAllSides,
			this.Const.Perks.PerkDefs.PTRSurvivalInstinct,
			this.Const.Perks.PerkDefs.PTRKnowTheirWeakness,
			this.Const.Perks.PerkDefs.PTRFreshAndFurious,
			this.Const.Perks.PerkDefs.PTRVigilant,
			this.Const.Perks.PerkDefs.PTRPersonalArmor,
			this.Const.Perks.PerkDefs.PTRTunnelVision,
			this.Const.Perks.PerkDefs.PTRMenacing,
			this.Const.Perks.PerkDefs.PTRAlwaysAnEntertainer,
			this.Const.Perks.PerkDefs.PTREasyTarget,
		]);

		_lib[1].extend([
			this.Const.Perks.PerkDefs.PTRDeadlyPrecision,
			this.Const.Perks.PerkDefs.PTRBulwark,
			this.Const.Perks.PerkDefs.PTRExploitOpening,
			this.Const.Perks.PerkDefs.PTRTempo,
			this.Const.Perks.PerkDefs.PTRPatternRecognition,
			this.Const.Perks.PerkDefs.PTRDynamicDuo,
			this.Const.Perks.PerkDefs.PTRStrengthInNumbers,
			this.Const.Perks.PerkDefs.PTRWearsItWell,
			this.Const.Perks.PerkDefs.PTRBully,
			this.Const.Perks.PerkDefs.PTRPaintASmile,
			this.Const.Perks.PerkDefs.PTRDiscoveredTalent,
			this.Const.Perks.PerkDefs.PTRManOfSteel,
		]);

		_lib[2].extend([
			this.Const.Perks.PerkDefs.PTRRisingStar,
			this.Const.Perks.PerkDefs.PTRTheRushOfBattle,
			this.Const.Perks.PerkDefs.PTRFruitsOfLabor,
			this.Const.Perks.PerkDefs.PTRWearThemDown,
			this.Const.Perks.PerkDefs.PTRUnstoppable,
			this.Const.Perks.PerkDefs.PTRWhackASmack,
			this.Const.Perks.PerkDefs.PTRLightWeapon,
		]);
		
		if (_hasAoE)
		{
			_lib[1].push(this.Const.Perks.PerkDefs.PTRSweepingStrikes);
			_lib[2].push(this.Const.Perks.PerkDefs.PTRBloodyHarvest);
		}

		local damageTypes = [];

		foreach( active in _skillsContainer.m.Skills )
		{
			if (active.isGarbage() || !active.isActive())
			{
				continue;
			}

			local damageType = active.getDamageType();

			if (damageType.len() == 0)
			{
				continue;
			}

			damageTypes.extend(damageType);
		}

		if (_isSpecial)
		{
			damageTypes.push({
				Type = this.Const.Damage.DamageType.Piercing,
				Weight = 100
			});
		}

		this.getPerksForDamageType(_lib, damageTypes);
	}

	function getLib()
	{
		return [
			[
				this.Const.Perks.PerkDefs.LegendBackToBasics,
				this.Const.Perks.PerkDefs.Colossus,
				this.Const.Perks.PerkDefs.LegendAlert,
				this.Const.Perks.PerkDefs.CripplingStrikes,
				this.Const.Perks.PerkDefs.Pathfinder,
				this.Const.Perks.PerkDefs.SunderingStrikes,
				this.Const.Perks.PerkDefs.LegendBlendIn,
				this.Const.Perks.PerkDefs.NineLives,
				this.Const.Perks.PerkDefs.FastAdaption,
				this.Const.Perks.PerkDefs.Adrenalin,
				this.Const.Perks.PerkDefs.BagsAndBelts,
				this.Const.Perks.PerkDefs.Recover,
				this.Const.Perks.PerkDefs.Backstabber,
				this.Const.Perks.PerkDefs.SteelBrow,
				this.Const.Perks.PerkDefs.Dodge,
				this.Const.Perks.PerkDefs.LegendComposure,
				this.Const.Perks.PerkDefs.LegendTrueBeliever,
				this.Const.Perks.PerkDefs.LegendEvasion,
				this.Const.Perks.PerkDefs.FortifiedMind,
				this.Const.Perks.PerkDefs.Anticipation,
				this.Const.Perks.PerkDefs.Steadfast,
				this.Const.Perks.PerkDefs.LegendOnslaught,
				this.Const.Perks.PerkDefs.Feint,
				this.Const.Perks.PerkDefs.CoupDeGrace,
				this.Const.Perks.PerkDefs.HoldOut,
				this.Const.Perks.PerkDefs.Sprint,
				this.Const.Perks.PerkDefs.Footwork,
				this.Const.Perks.PerkDefs.LegendLacerate,
				this.Const.Perks.PerkDefs.Relentless,
				this.Const.Perks.PerkDefs.Taunt,
				this.Const.Perks.PerkDefs.Rotation,
				this.Const.Perks.PerkDefs.LegendSmackdown,
				this.Const.Perks.PerkDefs.Debilitate,
				this.Const.Perks.PerkDefs.LegendHidden,
				this.Const.Perks.PerkDefs.Gifted,
				this.Const.Perks.PerkDefs.QuickHands,
			],
			[
				this.Const.Perks.PerkDefs.Gifted,
				this.Const.Perks.PerkDefs.LegendComposure,
				this.Const.Perks.PerkDefs.Sprint,
				this.Const.Perks.PerkDefs.LegendTrueBeliever,
				this.Const.Perks.PerkDefs.LegendHairSplitter,
				this.Const.Perks.PerkDefs.Underdog,
				this.Const.Perks.PerkDefs.LegendLithe
				this.Const.Perks.PerkDefs.LegendBloodbath,
				this.Const.Perks.PerkDefs.LoneWolf,
				this.Const.Perks.PerkDefs.Stalwart,
				this.Const.Perks.PerkDefs.Overwhelm,
				this.Const.Perks.PerkDefs.LegendClarity,
				this.Const.Perks.PerkDefs.LegendEscapeArtist,
				this.Const.Perks.PerkDefs.PushTheAdvantage,
				this.Const.Perks.PerkDefs.LegendGatherer,
				this.Const.Perks.PerkDefs.LegendTerrifyingVisage,
				this.Const.Perks.PerkDefs.LegendAssuredConquest,
				this.Const.Perks.PerkDefs.LegendSecondWind,
				this.Const.Perks.PerkDefs.HeadHunter,
				this.Const.Perks.PerkDefs.DoubleStrike,
				this.Const.Perks.PerkDefs.DevastatingStrikes,
				this.Const.Perks.PerkDefs.LegendEfficientPacking,
				this.Const.Perks.PerkDefs.LegendSkillfulStacking,
			],
			[
				this.Const.Perks.PerkDefs.LegendHairSplitter,
				this.Const.Perks.PerkDefs.LegendTerrifyingVisage,
				this.Const.Perks.PerkDefs.InspiringPresence,
				this.Const.Perks.PerkDefs.Berserk,
				this.Const.Perks.PerkDefs.LegendTumble,
				this.Const.Perks.PerkDefs.LegendFullForce,
				this.Const.Perks.PerkDefs.Vengeance,
				this.Const.Perks.PerkDefs.LegendMindOverBody,
				this.Const.Perks.PerkDefs.ReturnFavor,
				this.Const.Perks.PerkDefs.KillingFrenzy,
				this.Const.Perks.PerkDefs.Fearsome,
				this.Const.Perks.PerkDefs.LegendForcefulSwing,
				this.Const.Perks.PerkDefs.PerfectFocus
				this.Const.Perks.PerkDefs.Indomitable,
				this.Const.Perks.PerkDefs.LegendSlaughter,
				this.Const.Perks.PerkDefs.LegendFreedomOfMovement,
				this.Const.Perks.PerkDefs.LastStand,
				this.Const.Perks.PerkDefs.Rebound,
				this.Const.Perks.PerkDefs.BattleFlow,
			],
		];
	}

	function getEnemyLib()
	{
		return [
			[
				this.Const.Perks.PerkDefs.LegendFavouredEnemyGhoul,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyDirewolf,
				this.Const.Perks.PerkDefs.LegendFavouredEnemySpider,
				this.Const.Perks.PerkDefs.LegendFavouredEnemySkeleton,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyZombie,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyCaravan,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyMercenary,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyNoble,
				this.Const.Perks.PerkDefs.LegendFavouredEnemySoutherner,
			],
			[
				this.Const.Perks.PerkDefs.LegendFavouredEnemyVampire,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyAlps,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyOrk,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyGoblin,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyBandit,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyNomad,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyBarbarian,
			],
			[
				this.Const.Perks.PerkDefs.LegendFavouredEnemyHexen,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyUnhold,
				this.Const.Perks.PerkDefs.LegendFavouredEnemySchrat,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyLindwurm,
				this.Const.Perks.PerkDefs.LegendFavouredEnemyArcher,
				this.Const.Perks.PerkDefs.LegendFavouredEnemySwordmaster,
			],
		];
	}

};