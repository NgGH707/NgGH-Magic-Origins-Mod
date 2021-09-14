this.luft_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		NewPerkTree = null,
		DayCount = 0,
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.luft";
		this.m.Name = "Skin Ghoul Mascot";
		this.m.Icon = "ui/backgrounds/background_luft.png";
		this.m.HiringCost = 9999999;
		this.m.DailyCost = 0;
		this.m.Excluded = [
			"trait.dumb",
			"trait.superstitious",
		];
		this.m.Names = ["Luft"];
		this.m.Titles = ["The Rat Enjoyer"];

		this.addBackgroundType(this.Const.BackgroundType.Educated);
		this.addBackgroundType(this.Const.BackgroundType.Noble);
		this.addBackgroundType(this.Const.BackgroundType.Performing);

		this.m.AlignmentMin = this.Const.LegendMod.Alignment.Dreaded;
		this.m.AlignmentMax = this.Const.LegendMod.Alignment.Merciless;
		this.m.Modifiers.Meds = this.Const.LegendMod.ResourceModifiers.Meds[2];
		this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[0];
		this.m.Modifiers.Healing = this.Const.LegendMod.ResourceModifiers.Healing[3];
		this.m.Modifiers.Crafting = this.Const.LegendMod.ResourceModifiers.Crafting[1];
		this.m.Modifiers.Enchanting = 1.0;
		
		this.m.CustomPerkTree = [
			[
				this.Const.Perks.PerkDefs.FastAdaption,
				this.Const.Perks.PerkDefs.CoupDeGrace,
				this.Const.Perks.PerkDefs.Backstabber,
				this.Const.Perks.PerkDefs.Pathfinder,
				this.Const.Perks.PerkDefs.CripplingStrikes,
				this.Const.Perks.PerkDefs.LegendOnslaught,
				this.Const.Perks.PerkDefs.LegendAlert,
				this.Const.Perks.PerkDefs.Recover,
			],
			[
				this.Const.Perks.PerkDefs.Dodge,
				this.Const.Perks.PerkDefs.SteelBrow,
				this.Const.Perks.PerkDefs.Gifted,
				this.Const.Perks.PerkDefs.Debilitate,
				this.Const.Perks.PerkDefs.SunderingStrikes,
				this.Const.Perks.PerkDefs.Taunt,
				this.Const.Perks.PerkDefs.NachoFrenzy,
				this.Const.Perks.PerkDefs.UnholyFruits,
				this.Const.Perks.PerkDefs.CharmEnemySpider,
			],
			[
				this.Const.Perks.PerkDefs.Anticipation,
				this.Const.Perks.PerkDefs.Sprint,
				this.Const.Perks.PerkDefs.Footwork,
				this.Const.Perks.PerkDefs.Rotation,
				this.Const.Perks.PerkDefs.DevastatingStrikes,
				this.Const.Perks.PerkDefs.InspiringPresence,
				this.Const.Perks.PerkDefs.CharmEnemyAlps,
				this.Const.Perks.PerkDefs.CharmEnemyDirewolf,
			],
			[
				this.Const.Perks.PerkDefs.Adrenalin,
				this.Const.Perks.PerkDefs.Underdog,
				this.Const.Perks.PerkDefs.LegendLeap,
				this.Const.Perks.PerkDefs.Fearsome,
				this.Const.Perks.PerkDefs.Inspire,
				this.Const.Perks.PerkDefs.FortifiedMind,
				this.Const.Perks.PerkDefs.LegendMindOverBody,
				this.Const.Perks.PerkDefs.PattingSpec,
				this.Const.Perks.PerkDefs.InnocentLook,
				this.Const.Perks.PerkDefs.CharmEnemyGhoul,
			],
			[
				this.Const.Perks.PerkDefs.PushTheAdvantage,
				this.Const.Perks.PerkDefs.LegendLithe,
				this.Const.Perks.PerkDefs.Steadfast,
				this.Const.Perks.PerkDefs.Rebound,
				this.Const.Perks.PerkDefs.LoneWolf,
				this.Const.Perks.PerkDefs.NachoEat,
				this.Const.Perks.PerkDefs.CharmEnemyGoblin,
				this.Const.Perks.PerkDefs.CharmEnemyOrk,
			],
			[
				this.Const.Perks.PerkDefs.KillingFrenzy,
				this.Const.Perks.PerkDefs.LegendAssuredConquest,
				this.Const.Perks.PerkDefs.LegendTerrifyingVisage,
				this.Const.Perks.PerkDefs.Berserk,
				this.Const.Perks.PerkDefs.LastStand,
				this.Const.Perks.PerkDefs.Nimble,
				this.Const.Perks.PerkDefs.Nacho,
				this.Const.Perks.PerkDefs.CharmEnemyUnhold,
				this.Const.Perks.PerkDefs.CharmEnemySchrat,
			],
			[
				this.Const.Perks.PerkDefs.Colossus,
				this.Const.Perks.PerkDefs.LegendMuscularity,
				this.Const.Perks.PerkDefs.PerfectFocus,
				this.Const.Perks.PerkDefs.BattleFlow,
				this.Const.Perks.PerkDefs.Indomitable,
				this.Const.Perks.PerkDefs.CharmSpec,
				this.Const.Perks.PerkDefs.GhoulBeauty,
				this.Const.Perks.PerkDefs.CharmEnemyLindwurm,
			],
			[],
			[],
			[],
			[]
		];

		if (this.Math.rand(1, 100) == 7)
		{
			this.m.CustomPerkTree[6].push(this.Const.Perks.PerkDefs.HexenChampion);
		}

		if (this.Math.rand(1, 100) >= 95)
		{
			this.m.CustomPerkTree[2].push(this.Const.Perks.PerkDefs.FairGame);
		}

		if (::mods_getRegisteredMod("mod_legends_PTR") != null)
		{
			this.addPerkTreesToCustomPerkTree(this.m.CustomPerkTree, [
				this.Const.Perks.ViciousTree,
				this.Const.Perks.LightArmorTree,
				this.Const.Perks.ResilientTree,
				this.Const.Perks.TalentedTree,
				this.Const.Perks.RangedTree
			]);

			this.m.CustomPerkTree[5].push(this.Const.Perks.PerkDefs.PTRUnstoppable);
			this.m.CustomPerkTree[5].push(this.Const.Perks.PerkDefs.PTRFreshAndFurious);
			this.m.CustomPerkTree[5].push(this.Const.Perks.PerkDefs.PTRTheRushOfBattle);
		}

		this.m.NewPerkTree = clone this.m.CustomPerkTree;
	}

	function addPerkTreesToCustomPerkTree(_customPerkTree, _treesToAdd)
	{
		foreach (tree in _treesToAdd)
		{
			for (local i = 0; i < tree.Tree.len(); i++)
			{
				foreach (perk in tree.Tree[i])
				{
					_customPerkTree[i].push(perk);
				}
			}
		}
	}
	
	function resetPerkTree()
	{
		local pT = this.Const.Perks.BuildCustomPerkTree(this.m.NewPerkTree);
		this.m.PerkTree = pT.Tree;
		this.m.PerkTreeMap = pT.Map;
		this.m.CustomPerkTree = this.m.NewPerkTree;
	}

	function getTooltip()
	{
		local size = this.getContainer().getActor().getSize();
		local days = this.getContainer().getActor().getFlags().getAsInt("hunger") + 1;
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to [color=" + this.Const.UI.Color.NegativeValue + "]Charm[/color] and [color=" + this.Const.UI.Color.NegativeValue + "]Hex[/color]"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Likes to pet everything"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Discord Mod"
			}
			{
				id = 15,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Higher Chance To Hit Head"
			}
		];

		if (size != 1)
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Has enough nutrients to stay fit for [color=" + this.Const.UI.Color.NegativeValue + "]" + days + "[/color] day(s)"
			});
		}

		ret.extend(this.getAttributesTooltip());
		return ret;
	}
	
	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += 10;
	}

	function onBuildDescription()
	{
		return "You know him when you join BB Legends Mod discord. The one and only lovable nacho who know more than scratching and eating, he can pet you and charm you. With his sassy ghoulish body and cute jester hat, no nacho can resist his call. \n\nHe likes to pet everything from Unholds, Direwolves to his own nacho buddies, Poss, discord members. His pat meets no bounds, if he saw you, he will pet you. \n\nPssss! Some said he ate discord member for dinner.";
	}

	function buildAttributes( _tag = null, _attrs = null )
	{
		local b = this.getContainer().getActor().getBaseProperties();
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
		local weighted = [];
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);
		weighted.push(50);

		return weighted;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		
		items.equip(this.Const.World.Common.pickHelmet([
			[
				1,
				"jesters_hat"
			],
		]));
	}
	
	function onMakePlayerCharacter()
	{
		local a = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				5,
				10
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				40,
				45
			],
			RangedSkill = [
				50,
				55
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				0
			]
		};
		local b = this.getContainer().getActor().getBaseProperties();
		b.Hitpoints += this.Math.rand(a.Hitpoints[0], a.Hitpoints[1]);
		b.Bravery += this.Math.rand(a.Bravery[0], a.Bravery[1]);
		b.Stamina += this.Math.rand(a.Stamina[0], a.Stamina[1]);
		b.MeleeSkill += this.Math.rand(a.MeleeSkill[0], a.MeleeSkill[1]);
		b.RangedSkill += this.Math.rand(a.RangedSkill[0], a.RangedSkill[1]);
		b.MeleeDefense += this.Math.rand(a.MeleeDefense[0], a.MeleeDefense[1]);
		b.RangedDefense += this.Math.rand(a.RangedDefense[0], a.RangedDefense[1]);
		b.Initiative += this.Math.rand(a.Initiative[0], a.Initiative[1]);
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
	}
	
	function setAppearance()
	{
		return;
	}
	
	function onNewDay()
	{
		local name = this.getContainer().getActor().getNameOnly();
		local wrongName = name.find("Luft") == null;
		local title = this.getContainer().getActor().m.Title;
		local wrongTitle = title.len() == 0 || title.find("Rat Enjoyer") == null;
		
		if (wrongName)
		{
			this.getContainer().getActor().setName("Luft");
			this.getContainer().getActor().worsenMood(0.5, "My name is Luft. Quit changing it");
		}
		
		if (wrongTitle)
		{
			this.getContainer().getActor().setTitle("The Rat Enjoyer");
			this.getContainer().getActor().worsenMood(0.5, "I like rat. Please don\'t changing it");
		}

		local actor = this.getContainer().getActor();
		local size = actor.getSize();
		local days = actor.getFlags().getAsInt("hunger");

		if (size == 1)
		{
			return;
		}

		days = days - 1;

		if (days <= -1)
		{
			local newSize = this.Math.max(1, actor.getSize() - 1);
			actor.setSize(newSize);
			actor.getFlags().set("hunger", 2);
			this.World.Flags.set("looks",  9990 + newSize);
			this.World.Assets.updateLook( 9990 + newSize);
			return;
		}

		actor.getFlags().set("hunger", days);
	}

	function onCombatFinished()
	{
		local looks = this.World.Flags.getAsInt("looks");
		local size = 9990 + this.getContainer().getActor().getSize();

		if (looks != size)
		{
			this.World.Flags.set("looks", size);
			this.World.Assets.updateLook(size);
		}
	}

	function resetDays() 
	{
	   this.m.DayCount = 3;
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.DayCount);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.DayCount = _in.readU8();
	}

});

