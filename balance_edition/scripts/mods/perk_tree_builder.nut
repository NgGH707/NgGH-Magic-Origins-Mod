this.perk_tree_builder <- {
	m = {},
	
	function fillWithRandomPerk( _tree , _addWeapon = false , _hasAoE = false )
	{
		local Perks = {
			PerkDefs = [],
			Row = [],
		};
		local perkPerRow = [8, 7, 6, 8, 6, 6, 5, 4, 4, 4, 4];
		local perkAddPerRow = [];
		local tools = {};
		tools.hasPerk <- function( _table, _perk )
		{
			foreach ( p in _table.PerkDefs )
			{
				if (p == _perk)
				{
					return true;
				}
			}

			return false;
		};
		tools.isInTree <- function ( _treeMap, _perk )
		{
			foreach( row in _treeMap )
			{
				foreach( p in row )
				{
					if (p == _perk)
					{
						return true;
					}
				}
			}

			return false;
		};
		tools.removePerk <- function( _perkLib , _perk )
		{
			foreach ( _l in _perkLib )
			{
				local index = _l.find(_perk);

				if (index != null)
				{
					_l.remove(index);
					return;
				}
			}
		}
		tools.removeExistingPerks <- function ( _treeMap, _perkLib ) 
		{
			local remove = [];

		    foreach ( _l in _perkLib )
			{
				foreach ( i, _p in _l )
				{
					if (this.isInTree(_treeMap, _p))
					{
						remove.push(_p);
					}
				}
			}

			foreach ( perk in remove )
			{
				this.removePerk(_perkLib, perk)
			}
		};
		
		if (_addWeapon)
		{
			local Map = [];
			local excluded = [];
			
			for ( local i = 0 ; i < 2 ; i = ++i )
			{
				local t = this.Const.Perks.MeleeWeaponTrees.getRandom(excluded);
				excluded.push(t.ID);
				Map.push(t);
			}
			
			if (this.Math.rand(1, 10) <= 5)
			{
				local t = this.Const.Perks.RangedWeaponTrees.getRandom(null);
				Map.push(t);
			}
			else
			{
				Map.push(this.Const.Perks.ShieldTree);
			}
			
			foreach( mT in Map )
			{
				foreach( i, row in mT.Tree )
				{
					foreach( p in row )
					{
						if (tools.isInTree(_tree, p))
						{
							continue;
						}

						_tree[i].push(p);
					}
				}
			}
		}
		
		local perkFavourNum = this.Math.rand(1, 3);
		perkFavourNum = perkFavourNum == 3 ? this.Math.rand(1, 3) : perkFavourNum;
		
		for ( local i = 0 ; i < 7 ; i = ++i )
		{
			local numRow = _tree[i].len();
			local different = this.Math.max(0, perkPerRow[i] - numRow)
			local perkNeedToBeAdded =  different + this.Math.rand(0, 2);
			perkAddPerRow.push(this.Math.max(this.Math.min(perkNeedToBeAdded, 13 - numRow), 0));
		}

		perkAddPerRow[3] += perkFavourNum;
		
		local lb = [
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
				this.Const.Perks.PerkDefs.Nimble,
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
				this.Const.Perks.PerkDefs.LegendMuscularity,
				this.Const.Perks.PerkDefs.LastStand,
				this.Const.Perks.PerkDefs.Rebound,
				this.Const.Perks.PerkDefs.BattleFlow,
			],
		];
		local lbE = [
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
		
		this.addPTR_Perks(lb, _hasAoE);
		tools.removeExistingPerks(_tree, lb);
		tools.removeExistingPerks(_tree, lbE);
		
		for ( local i = 0 ; i < 3 ; i = ++i )
		{
			for ( local j = 0 ; j < perkAddPerRow[i] ; j = j )
			{
				if (lb[0].len() <= 0)
				{
					break;
				}
				
				local index = ::mc_randArrayIndex(lb[0]);
				
				if (lb[0][index] != null && !tools.hasPerk(Perks, lb[0][index]))
				{
					Perks.PerkDefs.push(lb[0][index]);
					Perks.Row.push(i);
					j = ++j;
				}
			}
		}


		for ( local i = 3 ; i < 5 ; i = ++i )
		{
			for ( local j = 0 ; j < perkAddPerRow[i] ; j = ++j )
			{
				if (lb[1].len() <= 0)
				{
					break;
				}
				
				local index = ::mc_randArrayIndex(lb[1]);
				
				if (lb[1][index] != null && !tools.hasPerk(Perks, lb[1][index]))
				{
					Perks.PerkDefs.push(lb[1][index]);
					Perks.Row.push(i);
					j = ++j;
				}
			}
		}

		for ( local i = 5 ; i < 7 ; i = ++i )
		{
			for ( local j = 0 ; j < perkAddPerRow[i] ; j = ++j )
			{
				if (lb[2].len() == 0)
				{
					break;
				}
				
				local index = ::mc_randArrayIndex(lb[2]);
				
				if (lb[2][index] != null && !tools.hasPerk(Perks, lb[2][index]))
				{
					Perks.PerkDefs.push(lb[2][index]);
					Perks.Row.push(i);
					j = ++j;
				}
			}
		}
		
		for ( local i = 0 ; i < perkFavourNum ; i = ++i )
		{
			local r = this.Math.rand(0, 2);
			local index = ::mc_randArrayIndex(lbE[r]);
			
			if (lbE[r][index] != null)
			{
				Perks.PerkDefs.push(lbE[r][index]);
				Perks.Row.push(3);
				lbE[r].remove(index);
			}
		}
		
		local result = {
			Tree = _tree,
			Data = Perks,
		}
		
		return result;
	}

	function addPTR_Perks( _lib , _hasAoE = false )
	{
		if (::mods_getRegisteredMod("mod_legends_PTR") == null)
		{
			return;
		}

		_lib[0].extend([
			this.Const.Perks.PerkDefs.PTRSmallTarget,
			this.Const.Perks.PerkDefs.PTRHeadSmasher,
			this.Const.Perks.PerkDefs.PTRSurvivalInstinct,
			this.Const.Perks.PerkDefs.PTRDiscoveredTalent,
			this.Const.Perks.PerkDefs.PTRRisingStar,
			this.Const.Perks.PerkDefs.PTRFreshAndFurious,
			this.Const.Perks.PerkDefs.PTRStrengthInNumbers,
			this.Const.Perks.PerkDefs.PTRFruitsOfLabor,
		]);

		_lib[1].extend([
			this.Const.Perks.PerkDefs.PTRSanguinary,
			this.Const.Perks.PerkDefs.PTRBearDown,
			//this.Const.Perks.PerkDefs.PTRHeightenedReflexes,
			this.Const.Perks.PerkDefs.PTRWearThemDown,
			this.Const.Perks.PerkDefs.PTRKnowTheirWeakness,
			this.Const.Perks.PerkDefs.PTRPersonalArmor,
			this.Const.Perks.PerkDefs.PTRTunnelVision,
		]);

		_lib[2].extend([
			this.Const.Perks.PerkDefs.PTRBloodlust,
			this.Const.Perks.PerkDefs.PTRBloodbath,
			this.Const.Perks.PerkDefs.PTRUnstoppable,
			this.Const.Perks.PerkDefs.PTRTheRushOfBattle,
			this.Const.Perks.PerkDefs.PTRExudeConfidence,
		]);
		
		if (_hasAoE)
		{
			_lib[1].push(this.Const.Perks.PerkDefs.PTRSweepingStrikes);
			_lib[2].push(this.Const.Perks.PerkDefs.PTRBloodyHarvest);
		}
	}
};