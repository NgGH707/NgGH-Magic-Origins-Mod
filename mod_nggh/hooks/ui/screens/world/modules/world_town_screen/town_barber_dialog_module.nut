::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_barber_dialog_module", function(obj) 
{
	obj.queryRosterInformation = function()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local roster = [];

		foreach( b in brothers )
		{
			if (b.getFlags().has("nggh_character") && !b.canEnterBarber())
			{
				continue;
			}

			local background = b.getBackground();
			local e = {
				ID = b.getID(),
				Name = b.getName(),
				ImagePath = b.getImagePath(),
				ImageOffsetX = b.getImageOffsetX(),
				ImageOffsetY = b.getImageOffsetY(),
				BackgroundImagePath = background.getIconColored(),
				BackgroundText = background.getDescription()
			};
			roster.push(e);
		}

		return {
			Title = "Barber",
			SubTitle = "Customize the appearance of your mercenaries at the barber",
			Roster = roster,
			Assets = this.m.Parent.queryAssetsInformation()
		};
	}

	obj.onEntrySelected = function( _entityID )
	{
		local roster = ::World.getTemporaryRoster();
		roster.clear();

		local bro = ::Tactical.getEntityByID(_entityID);
		local script = bro.getFlags().has("nggh_character") ? ::IO.scriptFilenameByHash(bro.ClassNameHash) : "scripts/entity/tactical/human";
		local spriteToClone = bro.getFlags().has("nggh_character") ? bro.getBarberSpriteChange() : ::Const.CharmedUtilities.SpritesToCloneHuman;

		// create the model
		local temp = roster.create(script);

		// copy sprites
		temp.copySpritesFrom(bro, spriteToClone);
		temp.setDirty(true);
		return temp.getImagePath();
	}

	local ws_onUpdateAppearance = obj.onUpdateAppearance;
	obj.onUpdateAppearance = function( _data )
	{
		local _entityID = _data[0];
		local _layerID = _data[1];
		local _change = _data[2];
		local bro = ::Tactical.getEntityByID(_entityID);

		if (!bro.getFlags().has("nggh_character"))
		{
			return ws_onUpdateAppearance(_data);
		}

		local temp = ::World.getTemporaryRoster().getAll()[0];
		local color;

		if (_layerID == "body")
		{
			local custom = null;

			if (bro.getFlags().has("serpent"))
			{
				custom = {
					Variant = [1, 2, 2, 1],
				}
			}
			else
			{
				custom = {
					Variant = bro.getVariant()
				}
			}

			local result = this.changeIndexNonHuman(bro.getPossibleSprites(_layerID), temp.getSprite(_layerID), _change, custom);

			if (result != null)
			{
				temp.getFlags().set("variant", result);
			}
		}
		else if (_layerID == "head" && temp.hasSprite("head"))
		{
			local custom = null;
			local isNacho = bro.getFlags().has("ghoul") && bro.getSize() >= 2;

			if (bro.getFlags().has("frenzy") && bro.getFlags().get("Type") == ::Const.EntityType.Direwolf)
			{
				custom = {
					isFrenzy = true,
					Sprite = temp.getSprite("head_frenzy"),
				};
			}

			if (isNacho)
			{
				custom = {
					Variant = [1, 2, 3, 1, 2, 3],
				}
			}

			local result = this.changeIndexNonHuman(bro.getPossibleSprites(_layerID), temp.getSprite(_layerID), _change, custom);

			if (result != null && isNacho)
			{
				temp.getFlags().set("variant", result);
			}
		}
		else if (bro.getFlags().has("spider"))
		{
			if (_layerID == "hair")
			{
				this.changeIndexNonHuman(bro.getPossibleSprites("legs_back"), temp.getSprite("legs_back"), _change, null);
			}
			if (_layerID == "beard")
		    {
		    	this.changeIndexNonHuman(bro.getPossibleSprites("legs_front"), temp.getSprite("legs_front"), _change, null);
		    }
		}

		temp.setDirty(true);
		return temp.getImagePath();
	}

	obj.onChangeAppearance = function( _entityID )
	{
		local bro = ::Tactical.getEntityByID(_entityID);
		local temp = ::World.getTemporaryRoster().getAll()[0];
		local spriteToClone = bro.getFlags().has("nggh_character") ? bro.getBarberSpriteChange() : ::Const.CharmedUtilities.SpritesToCloneHuman;

		// clone sprite
		bro.copySpritesFrom(temp, spriteToClone);
		bro.setDirty(true);

		if (temp.getFlags().has("variant"))
		{
			bro.setVariant(temp.getFlags().getAsInt("variant"));
		}

		::Sound.play(::MSU.Array.rand(::Const.Sound.Barber), 1.0);
		return bro.getImagePath();
	}

	obj.changeIndexNonHuman <- function( _list, _sprite, _change , _custom )
	{
		if (_list.len() == 0)
		{
			return null;
		}

		local currentBrush = _sprite.HasBrush ? _sprite.getBrush().Name : "";
		local index = 0;

		foreach( i, s in _list )
		{
			if (s == currentBrush)
			{
				index = i;
				break;
			}
		}

		index += _change;

		if (index >= _list.len())
		{
			index = 0;
		}
		else if (index < 0)
		{
			index = _list.len() - 1;
		}

		if (_list[index] != "")
		{
			_sprite.setBrush(_list[index]);
		}
		else
		{
			_sprite.resetBrush();
		}

		if (_custom == null)
		{
			return null;
		}

		local ret;

		if (("isFrenzy" in _custom) && _custom.isFrenzy)
		{
			local frenzy = [
	        	"bust_direwolf_01_head",
	        	"bust_direwolf_02_head",
	        	"bust_direwolf_03_head",
	        	"bust_direwolf_01_head",
	        ];

	        if (frenzy[index] != "")
			{
				_custom.Sprite.setBrush(frenzy[index]);
			}
			else
			{
				_custom.Sprite.resetBrush();
			}
		}
		else if ("Variant" in _custom)
		{
			if (typeof _custom.Variant == "array")
			{
				return _custom.Variant[index];
			}

			return index + 1;
		}

		return ret;
	}
});