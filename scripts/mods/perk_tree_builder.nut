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

		if (::Is_PTR_Exist)
		{
			for ( local i = 0; i < 6; i = ++i ) 
			{
			    maxPerksPerRow[i] += 1;
			}
		}

		if (::Math.rand(1, 100) <= 50)
		{
			lib[0].extend(libE[0]);
			maxPerksPerRow[::Math.rand(0, 6)] += 1;
		}

		if (::Math.rand(1, 100) <= 50)
		{
			lib[1].extend(libE[1]);
			maxPerksPerRow[::Math.rand(0, 6)] += 1;
		}

		if (::Math.rand(1, 100) <= 50)
		{
			lib[2].extend(libE[2]);
		}
		
		this.addPTR_Perks(lib, _skillsContainer, _isSpecial, _hasAoE);
		tools.removeExistingPerks(lib, excludedPerks);
		
		for ( local i = 0 ; i < 20 ; ) 
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

		        	r = ::MSU.Array.rand(lib_to_choose);
		        }
		        while(tools.hasPerk(r , excludedPerks) && lib_to_choose.len() > 0)

		        if (r != null)
		        {
		        	excludedPerks.push(r);
		        	row.push(r);
		        }
		    }

		    ++i;
		}

		if (!_removeNimble && !tools.hasPerk(::Const.Perks.PerkDefs.Nimble , excludedPerks) && ::Math.rand(1, 100) <= this.m.NimbleChance)
		{
			excludedPerks.push(::Const.Perks.PerkDefs.Nimble);
			_tree[5].insert(0, ::Const.Perks.PerkDefs.Nimble);
		}

		if (!tools.hasPerk(::Const.Perks.PerkDefs.LegendMuscularity , excludedPerks) && ::Math.rand(1, 100) <= this.m.MuscularityChance)
		{
			excludedPerks.push(::Const.Perks.PerkDefs.LegendMuscularity);
			_tree[6].insert(0, ::Const.Perks.PerkDefs.LegendMuscularity);
		}

		if (!tools.hasPerk(::Const.Perks.PerkDefs.LegendBattleheart , excludedPerks) && ::Math.rand(1, 100) <= this.m.BattleHeartChance)
		{
			excludedPerks.push(::Const.Perks.PerkDefs.LegendBattleheart);
			_tree[6].insert(0, ::Const.Perks.PerkDefs.LegendBattleheart);
		}

		if (_addWeaponPerks)
		{
			local Map = [];
			local excluded = [];
			local addRangedPerks = ::Math.rand(1, 100) <= 50;
			local num = 2 + (addRangedPerks ? 1 : 0);
			
			for ( local i = 0 ; i < num ; )
			{
				local t = ::Const.Perks.MeleeWeaponTrees.getRandom(excluded);

				if (excluded.find(t.ID) == null)
				{
					excluded.push(t.ID);
					Map.push(t.Tree);
					++i;
				}
			}

			if (addRangedPerks)
			{
				for ( local i = 0 ; i < 2 ; )
				{
					local t = ::Const.Perks.RangedWeaponTrees.getRandom(excluded);

					if (excluded.find(t.ID) == null)
					{
						excluded.push(t.ID);
						Map.push(t.Tree);
						++i;
					}
				}
			}
			else 
			{
			    Map.push(::Const.Perks.ShieldTree.Tree);
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

		foreach ( type in _damageType )
		{
			switch (type) 
			{
			case ::Const.Damage.DamageType.Blunt:
				_lib[0].extend([
					::Const.Perks.PerkDefs.PTRRattle,
					::Const.Perks.PerkDefs.PTRDeepImpact,
				]);
				_lib[1].extend([
					::Const.Perks.PerkDefs.PTRSoftMetal,
					::Const.Perks.PerkDefs.PTRDismantle,
					::Const.Perks.PerkDefs.PTRBearDown,
				]);
				_lib[2].extend([
					::Const.Perks.PerkDefs.PTRDentArmor,
					::Const.Perks.PerkDefs.PTRHeavyStrikes,
					::Const.Perks.PerkDefs.PTRBoneBreaker,
				]);
				break;

			case ::Const.Damage.DamageType.Piercing:
				_lib[0].extend([
					::Const.Perks.PerkDefs.PTRBetweenTheRibs,
					::Const.Perks.PerkDefs.PTRPointyEnd,
				]);
				_lib[1].extend([
					::Const.Perks.PerkDefs.PTRThroughTheGaps,
				]);
				break;

			case ::Const.Damage.DamageType.Cutting:
				_lib[0].extend([
					::Const.Perks.PerkDefs.PTRDismemberment,
					::Const.Perks.PerkDefs.PTRBetweenTheEyes,
					::Const.Perks.PerkDefs.PTRVersatileWeapon,
				]);
				_lib[1].extend([
					::Const.Perks.PerkDefs.PTRDeepCuts,
					::Const.Perks.PerkDefs.PTRSanguinary,
					::Const.Perks.PerkDefs.PTRCull,
				]);
				_lib[2].extend([
					::Const.Perks.PerkDefs.PTRBloodlust,
					::Const.Perks.PerkDefs.PTRBloodbath,
					::Const.Perks.PerkDefs.PTRMauler,
				]);
				break;

			case ::Const.Damage.DamageType.Burning:
				break;
			}
		}
	}

	function addPTR_Perks( _lib , _skillsContainer , _isSpecial , _hasAoE = false )
	{
		if (!::Is_PTR_Exist)
		{
			return;
		}

		_lib[0].extend([
			::Const.Perks.PerkDefs.PTRSmallTarget,
			::Const.Perks.PerkDefs.PTRHeadSmasher,
			::Const.Perks.PerkDefs.PTRFromAllSides,
			::Const.Perks.PerkDefs.PTRSurvivalInstinct,
			::Const.Perks.PerkDefs.PTRFreshAndFurious,
			::Const.Perks.PerkDefs.PTRVigilant,
			::Const.Perks.PerkDefs.PTRPersonalArmor,
			::Const.Perks.PerkDefs.PTRTunnelVision,
			::Const.Perks.PerkDefs.PTRMenacing,
			::Const.Perks.PerkDefs.PTRAlwaysAnEntertainer,
			::Const.Perks.PerkDefs.PTREasyTarget,
			::Const.Perks.PerkDefs.PTRSavageStrength,
			::Const.Perks.PerkDefs.PTRStrengthInNumbers,
		]);

		_lib[1].extend([
			::Const.Perks.PerkDefs.PTRDeadlyPrecision,
			::Const.Perks.PerkDefs.PTRBulwark,
			::Const.Perks.PerkDefs.PTRExploitOpening,
			::Const.Perks.PerkDefs.PTRTempo,
			::Const.Perks.PerkDefs.PTRPatternRecognition,
			::Const.Perks.PerkDefs.PTRDynamicDuo,
			::Const.Perks.PerkDefs.PTRWearsItWell,
			::Const.Perks.PerkDefs.PTRBully,
			::Const.Perks.PerkDefs.PTRPaintASmile,
			::Const.Perks.PerkDefs.PTRDiscoveredTalent,
			::Const.Perks.PerkDefs.PTRManOfSteel,
			::Const.Perks.PerkDefs.PTRBestialVigor,
			::Const.Perks.PerkDefs.PTRKnowTheirWeakness,
			::Const.Perks.PerkDefs.PTRExudeConfidence,
		]);

		_lib[2].extend([
			::Const.Perks.PerkDefs.PTRHaleAndHearty,
			::Const.Perks.PerkDefs.PTRRisingStar,
			::Const.Perks.PerkDefs.PTRTheRushOfBattle,
			::Const.Perks.PerkDefs.PTRFruitsOfLabor,
			::Const.Perks.PerkDefs.PTRWearThemDown,
			::Const.Perks.PerkDefs.PTRUnstoppable,
			::Const.Perks.PerkDefs.PTRWhackASmack,
			::Const.Perks.PerkDefs.PTRLightWeapon,
			::Const.Perks.PerkDefs.PTRFeralRage,
		]);
		
		if (_hasAoE)
		{
			_lib[1].push(::Const.Perks.PerkDefs.PTRSweepingStrikes);
			_lib[2].push(::Const.Perks.PerkDefs.PTRBloodyHarvest);
		}

		local damageTypes = [];

		foreach( active in _skillsContainer.m.Skills )
		{
			if (active.isGarbage() || !active.isActive())
			{
				continue;
			}

			local t = active.getDamageType().toArray(true);

			if (t.len() == 0)
			{
				continue;
			}

			damageTypes.extend(t);
		}

		if (_isSpecial)
		{
			damageTypes.push(::Const.Damage.DamageType.Piercing);
		}

		this.getPerksForDamageType(_lib, damageTypes);
	}

	function getLib()
	{
		local ret = [];
		ret.extend(::Const.AvailablePerksForBeast);
		return ret;
	}

	function getEnemyLib()
	{
		local ret = [];
		ret.extend(::Const.AvailableFavourdPerks);
		return ret;
	}

};