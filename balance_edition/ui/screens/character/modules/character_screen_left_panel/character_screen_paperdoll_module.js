/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2013 - 2020
 *
 *  @Author:		Overhype Studios
 *  @Date:			24.01.2017 / Reworked: 26.11.2017
 *  @Description:	Paperdoll Module JS
 */
"use strict";

var CharacterScreenPaperdollModule = function (_parent, _dataSource) {
  this.mParent = _parent;
  this.mDataSource = _dataSource;

  // container
  this.mContainer = null;

  // equipment slots
  this.mLeftEquipmentSlots = {
    Accessory: {
      Container: null,
      ContainerIsBig: false,
      ContainerClasses: "is-top-big-offset",
      SlotType: CharacterScreenIdentifier.ItemSlot.Accessory,
      BackgroundImage: Path.GFX + Asset.SLOT_BACKGROUND_ACCESSORY,
	  BlockedImage: Path.GFX + 'ui/items/missing_component_70x70.png',
    },
    RightHand: {
      Container: null,
      ContainerIsBig: true,
      ContainerClasses: "is-big is-in-between-offset",
      SlotType: CharacterScreenIdentifier.ItemSlot.Mainhand,
      BackgroundImage: Path.GFX + Asset.SLOT_BACKGROUND_MAINHAND,
	  BlockedImage: Path.GFX + 'ui/items/missing_component_70x70.png',
    }
  };
  this.mMiddleEquipmentSlots = {
    Head: {
      Container: null,
      ContainerIsBig: false,
      ContainerClasses: "helm-is-top-small-offset",
      SlotType: CharacterScreenIdentifier.ItemSlot.Head,
      BackgroundImage: Path.GFX + Asset.SLOT_BACKGROUND_HELMET,
	  BlockedImage: Path.GFX + 'ui/items/missing_component_70x70.png',
    },
    Body: {
      Container: null,
      ContainerIsBig: true,
      ContainerClasses: "is-big body-is-in-between-offset",
      SlotType: CharacterScreenIdentifier.ItemSlot.Body,
      BackgroundImage: Path.GFX + Asset.SLOT_BACKGROUND_BODY,
	  BlockedImage: Path.GFX + 'ui/items/missing_component_70x70.png',
    }
  };

  this.mUpgradeButtons = [null, null, null, null, null, null];
  this.mHelmetUpgradeButtons = [null, null, null, null, null];

  this.mRightEquipmentSlots = {
    Ammo: {
      Container: null,
      ContainerIsBig: false,
      ContainerClasses: "is-top-big-offset",
      SlotType: CharacterScreenIdentifier.ItemSlot.Ammo,
      BackgroundImage: Path.GFX + Asset.SLOT_BACKGROUND_AMMO,
	  BlockedImage: Path.GFX + 'ui/items/missing_component_70x70.png',
    },
    LeftHand: {
      Container: null,
      ContainerIsBig: true,
      ContainerClasses: "is-big is-in-between-offset",
      SlotType: CharacterScreenIdentifier.ItemSlot.Offhand,
      BackgroundImage: Path.GFX + Asset.SLOT_BACKGROUND_OFFHAND,
	  BlockedImage: Path.GFX + 'ui/items/missing_component_70x70.png',
    }
  };

  // backpack - slot containers
  this.mBackpackSlots = null;

  this.registerDatasourceListener();
};

CharacterScreenPaperdollModule.prototype.createDIV = function (_parentDiv) {
  var self = this;

  // create: containers
  this.mContainer = $('<div class="paperdoll-module"/>');
  _parentDiv.append(this.mContainer);

  // create: equipment containers & layouts
  var leftEquipmentColumn = $('<div class="equipment-column"/>');
  this.mContainer.append(leftEquipmentColumn);
  var leftEquipmentColumnLayout = $(
    '<div class="l-equipment-column is-left"/>'
  );
  leftEquipmentColumn.append(leftEquipmentColumnLayout);

  var middleEquipmentColumn = $('<div class="equipment-column is-middle"/>');
  this.mContainer.append(middleEquipmentColumn);
  var middleEquipmentColumnLayout = $('<div class="l-equipment-column"/>');
  middleEquipmentColumn.append(middleEquipmentColumnLayout);


  var layout = $('<div class="l-button h-remove1"/>');
  middleEquipmentColumn.append(layout);

  this.mHelmetUpgradeButtons[0] = layout.createTextButton(
    "1",
    function (_event) {
      self.mDataSource.notifyBackendRemoveHelmetUpgrade(0);
    },
    "display-block",
    11
  );

  var layout = $('<div class="l-button h-remove2"/>');
  middleEquipmentColumn.append(layout);
  this.mHelmetUpgradeButtons[1] = layout.createTextButton(
    "2",
    function (_event) {
      self.mDataSource.notifyBackendRemoveHelmetUpgrade(1);
    },
    "display-block",
    11
  );

  var layout = $('<div class="l-button h-remove3"/>');
  middleEquipmentColumn.append(layout);
  this.mHelmetUpgradeButtons[2] = layout.createTextButton(
    "3",
    function (_event) {
      self.mDataSource.notifyBackendRemoveHelmetUpgrade(2);
    },
    "display-block",
    11
  );

  var layout = $('<div class="l-button h-remove5"/>');
  middleEquipmentColumn.append(layout);
  this.mHelmetUpgradeButtons[4] = layout.createTextButton(
    "3",
    function (_event) {
      self.mDataSource.notifyBackendRemoveHelmetUpgrade(4);
    },
    "display-block",
    11
  );

  var layout = $('<div class="l-button h-remove4"/>');
  middleEquipmentColumn.append(layout);
  this.mHelmetUpgradeButtons[3] = layout.createTextButton(
    "R",
    function (_event) {
      self.mDataSource.notifyBackendRemoveHelmetUpgrade(3);
    },
    "display-block",
    11
  );

  var layout = $('<div class="l-button remove1"/>');
  middleEquipmentColumn.append(layout);

  this.mUpgradeButtons[0] = layout.createTextButton(
    "1",
    function (_event) {
      self.mDataSource.notifyBackendRemoveArmorUpgrade(0);
    },
    "display-block",
    11
  );

  var layout = $('<div class="l-button remove2"/>');
  middleEquipmentColumn.append(layout);
  this.mUpgradeButtons[1] = layout.createTextButton(
    "2",
    function (_event) {
      self.mDataSource.notifyBackendRemoveArmorUpgrade(1);
    },
    "display-block",
    11
  );

  var layout = $('<div class="l-button remove3"/>');
  middleEquipmentColumn.append(layout);
  this.mUpgradeButtons[2] = layout.createTextButton(
    "3",
    function (_event) {
      self.mDataSource.notifyBackendRemoveArmorUpgrade(2);
    },
    "display-block",
    11
  );

  var layout = $('<div class="l-button remove4"/>');
  middleEquipmentColumn.append(layout);
  this.mUpgradeButtons[3] = layout.createTextButton(
    "4",
    function (_event) {
      self.mDataSource.notifyBackendRemoveArmorUpgrade(3);
    },
    "display-block",
    11
  );

  var layout = $('<div class="l-button remove5"/>');
  middleEquipmentColumn.append(layout);
  this.mUpgradeButtons[4] = layout.createTextButton(
    "5",
    function (_event) {
      self.mDataSource.notifyBackendRemoveArmorUpgrade(4);
    },
    "display-block",
    11
  );
  //btn5.enableButton(false)

  var layout = $('<div class="l-button remove6"/>');
  middleEquipmentColumn.append(layout);
  this.mUpgradeButtons[5] = layout.createTextButton(
    "R",
    function (_event) {
      self.mDataSource.notifyBackendRemoveArmorUpgrade(5);
    },
    "display-block",
    11
  );
  //btn6.enableButton(false)
  // var layout = $('<div class="l-button remove4"/>');
  // middleEquipmentColumn.append(layout);
  // var btn4 = layout.createImageButton(Path.GFX + "ui/icons/stat_screen_dmg_dealt.png", function (_event)
  // {
  //     //self.mDataSource.notifyBackendRemoveArmorUpgrade();
  // }, 'display-block', 6);

  var rightEquipmentColumn = $('<div class="equipment-column"/>');
  this.mContainer.append(rightEquipmentColumn);
  var rightEquipmentColumnLayout = $(
    '<div class="l-equipment-column is-right"/>'
  );
  rightEquipmentColumn.append(rightEquipmentColumnLayout);

  // create: equipment slots
  var screen = $(".character-screen");
  $.each(this.mLeftEquipmentSlots, function (_key, _value) {
    self.createEquipmentSlot(_value, leftEquipmentColumnLayout, screen);
  });
  $.each(this.mMiddleEquipmentSlots, function (_key, _value) {
    self.createEquipmentSlot(_value, middleEquipmentColumnLayout, screen);
  });
  $.each(this.mRightEquipmentSlots, function (_key, _value) {
    self.createEquipmentSlot(_value, rightEquipmentColumnLayout, screen);
  });

  // create: backpack containers & layouts
  var backpackRow = $(
    '<div class="backpack-row ui-control-character-screen-paperdoll-backpack-row"/>'
  );
  this.mContainer.append(backpackRow);
  var backpackRowLayout = $('<div class="l-backpack-row has-slot-4"/>');
  backpackRow.append(backpackRowLayout);

  // create: backpack slots
  this.mBackpackSlots = [];
  for (var i = 0; i < Constants.Game.MAX_BACKPACK_SLOTS; ++i) {
    this.mBackpackSlots.push(this.createBagSlot(i, backpackRowLayout, screen));
  }
};

CharacterScreenPaperdollModule.prototype.destroyDIV = function () {
  $.each(this.mLeftEquipmentSlots, function (_key, _value) {
    _value.Container.empty();
    _value.Container.remove();
    _value.Container = null;
  });

  $.each(this.mMiddleEquipmentSlots, function (_key, _value) {
    _value.Container.empty();
    _value.Container.remove();
    _value.Container = null;
  });

  $.each(this.mRightEquipmentSlots, function (_key, _value) {
    _value.Container.empty();
    _value.Container.remove();
    _value.Container = null;
  });

  for (var i = 0; i < this.mBackpackSlots.length; ++i) {
    this.mBackpackSlots[i].Container.empty();
    this.mBackpackSlots[i].Container.remove();
    this.mBackpackSlots[i].Container = null;
  }
  this.mBackpackSlots = null;

  this.mContainer.empty();
  this.mContainer.remove();
  this.mContainer = null;
};

CharacterScreenPaperdollModule.prototype.createBagSlot = function (
  _index,
  _parentDiv,
  _screenDiv
) {
  var self = this;

  var result = {};

  result[CharacterScreenIdentifier.ItemFlag.IsBagSlot] = true;
  result.ContainerIsBig = false;

  var layout = $(
    '<div id="backpack-slot-' +
    _index +
    '" class="l-slot-container is-backpack"/>'
  );
  _parentDiv.append(layout);

  result.Container = layout.createPaperdollItem(
    false,
    Path.GFX + Asset.SLOT_BACKGROUND_BAG
  );

  // update item data
  var itemData = result.Container.data("item");
  itemData.index = _index;
  itemData.owner = CharacterScreenIdentifier.ItemOwner.Backpack;

  // add event handler
  var dropHandler = function (_source, _target, _proxy) {
    //var sourceData = _source.data('item');
    var sourceData = _proxy.data("item");
    var targetData = _target.data("item");

    var sourceOwner =
      sourceData !== null && "owner" in sourceData ? sourceData.owner : null;
    var targetOwner =
      targetData !== null && "owner" in targetData ? targetData.owner : null;

    // dont allow drop animation just yet
    sourceData.isAllowedToDrop = false;
    _proxy.data("item", sourceData);

    if (sourceOwner === null || targetOwner === null) {
      console.info("Failed to drop item. Owners are invalid.");
      return;
    }

    var entityId =
      sourceData !== null && "entityId" in sourceData ?
      sourceData.entityId :
      null;
    var sourceItemId =
      sourceData !== null && "itemId" in sourceData ? sourceData.itemId : null;
    var sourceItemIdx =
      sourceData !== null && "index" in sourceData ? sourceData.index : null;
    var targetItemIdx =
      targetData !== null && "index" in targetData ? targetData.index : null;
    //var targetItemId = (targetData !== null && 'itemId' in targetData) ? targetData.itemId : null;
    var sourceSlotType =
      sourceData !== null && "slotType" in sourceData ?
      sourceData.slotType :
      null;
    var targetSlotType =
      targetData !== null && "slotType" in targetData ?
      targetData.slotType :
      null;
    var sourceIsBlockingOffhand =
      sourceData !== null && "isBlockingOffhand" in sourceData ?
      sourceData.isBlockingOffhand :
      false;
    var targetIsBlockingOffhand =
      targetData !== null && "isBlockingOffhand" in targetData ?
      targetData.isBlockingOffhand :
      false;
    var isUsable =
      sourceData !== null && "isUsable" in sourceData ?
      sourceData.isUsable :
      false;

    if (sourceOwner === CharacterScreenIdentifier.ItemOwner.Ground) {
      // bullshit hack, fu imp
      $(".is-equipable").each(function () {
        $(this).removeClass("is-equipable");
      });
    }

    // don't allow helmets / armor within the bags
    if (
      targetOwner === CharacterScreenIdentifier.ItemOwner.Backpack &&
      sourceData.isAllowedInBag == false &&
      !isUsable
    ) {
      console.warn(
        "Backpack::dropHandler: Dropping Head | Body in Backpack is not allowed!"
      );
      return;
    }

    // don't allow swapping within the bag container - for now!
    if (
      sourceOwner === CharacterScreenIdentifier.ItemOwner.Backpack &&
      targetOwner === CharacterScreenIdentifier.ItemOwner.Backpack
    ) {
      // allow drop animation
      sourceData.isAllowedToDrop = true;
      _proxy.data("item", sourceData);

      console.info("Backpack -> Backpack (swap)");
      self.mDataSource.swapBagItem(entityId, sourceItemIdx, targetItemIdx);
      return;
    }

    // enough APs ?
    if (self.mDataSource.hasEnoughAPToEquip() === false) {
      console.info("Backpack::dropHandler: Not enough Action points!");
      return;
    }

    // from Stash | Ground -> Backpack
    if (
      targetOwner === CharacterScreenIdentifier.ItemOwner.Backpack &&
      (sourceOwner === CharacterScreenIdentifier.ItemOwner.Stash ||
        sourceOwner === CharacterScreenIdentifier.ItemOwner.Ground)
    ) {
      // allow drop animation
      sourceData.isAllowedToDrop = true;
      _proxy.data("item", sourceData);

      console.info(
        "Stash | Ground -> Backpack (targetItemIdx: " + targetItemIdx + ")"
      );
      self.mDataSource.dropInventoryItemIntoBag(
        entityId,
        sourceItemId,
        sourceItemIdx,
        targetItemIdx
      );
      return;
    }

    // from Paperdoll -> Backpack
    if (
      targetOwner === CharacterScreenIdentifier.ItemOwner.Backpack &&
      sourceOwner === CharacterScreenIdentifier.ItemOwner.Paperdoll
    ) {
      if (sourceData.isAllowedInBag === false) {
        console.info("Backpack::dropHandler: Not allowed in bag!");
        return;
      }

      var ignoreSlotType = false;

      if (
        sourceSlotType === CharacterScreenIdentifier.ItemSlot.Offhand &&
        sourceIsBlockingOffhand === false &&
        (targetSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand &&
          targetIsBlockingOffhand) &&
        self.mDataSource.hasItemEquipped(
          CharacterScreenIdentifier.ItemSlot.Mainhand
        )
      ) {
        console.info("Backpack::dropHandler: Not enough bag space!");
        return;
      }

      // Special Case: Source = Twohander and Target = Offhand and Inventory = Stash and Main & Offhand are filled with Item and Stash = full
      if (
        targetSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand &&
        targetIsBlockingOffhand === true &&
        (sourceSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand ||
          sourceSlotType === CharacterScreenIdentifier.ItemSlot.Offhand)
      ) {
        if (
          self.mDataSource.hasItemEquipped(
            CharacterScreenIdentifier.ItemSlot.Mainhand
          ) &&
          self.mDataSource.hasItemEquipped(
            CharacterScreenIdentifier.ItemSlot.Offhand
          ) &&
          self.mDataSource.isBagSpaceLeft(1) === false
        ) {
          console.info("Backpack::dropHandler: Not enough bag space!");
          return;
        }

        ignoreSlotType = true;
      }

      if (
        sourceSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand &&
        sourceIsBlockingOffhand &&
        (targetSlotType === CharacterScreenIdentifier.ItemSlot.Offhand ||
          targetSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand)
      ) {
        ignoreSlotType = true;
      }

      // Same Slot type ?
      if (ignoreSlotType === false && targetSlotType !== null) {
        if (sourceSlotType !== targetSlotType) {
          console.info(
            "Backpack::dropHandler: Item must be the same slot type!"
          );
          return;
        }
      }

      // allow drop animation
      sourceData.isAllowedToDrop = true;
      _proxy.data("item", sourceData);

      console.info(
        "Paperdoll -> Backpack (targetItemIdx: " + targetItemIdx + ")"
      );
      self.mDataSource.dropPaperdollItemIntoBag(
        entityId,
        sourceItemId,
        targetItemIdx
      );
    }
  };

  var dragEndHandler = function (_source, _target, _proxy) {
    $(".is-equipable").each(function () {
      $(this).removeClass("is-equipable");
    });

    if (_source.length === 0 || _target.length === 0) {
      return false;
    }

    //var sourceData = _source.data('item');
    var sourceData = _proxy.data("item");
    //var targetData = _target.data('item');
    //var proxyData = _source.data('item');

    /*
         console.info('dragEndHandler: #1');
         console.info(sourceData);
         console.info(targetData);
         //console.info(proxyData);
         */

    var isAllowedToDrop =
      sourceData !== null && "isAllowedToDrop" in sourceData ?
      sourceData.isAllowedToDrop :
      false;
    if (isAllowedToDrop === false) {
      console.info(
        "Backpack::dragEndHandler: Failed to drop item. Not allowed."
      );
      return false;
    }

    self.mDataSource.getInventoryModule().updateSlotsLabel();

    return true;
  };

  var dragStartHandler = function (_source, _proxy) {
    var paperdollModule = $(".paperdoll-module");

    if (_source.length === 0) {
      return false;
    }

    //var sourceData = _source.data('item');
    var sourceData = _proxy.data("item");
    //var proxyData = _source.data('item');
    var sourceSlotType =
      sourceData !== null && "slotType" in sourceData ?
      sourceData.slotType :
      null;
    //console.log("Source data: " + sourceSlotType);

    switch (sourceSlotType) {
      case CharacterScreenIdentifier.ItemSlot.Mainhand:
        var leftColumn = paperdollModule.find(".equipment-column:first");
        var mainhandContainer = leftColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame.is-big:first"
        );
        mainhandContainer.addClass("is-equipable");
        break;
      case CharacterScreenIdentifier.ItemSlot.Head:
        var middleColumn = paperdollModule.find(".equipment-column:eq(1)");
        var headContainer = middleColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame:first"
        );
        headContainer.addClass("is-equipable");
        break;
      case CharacterScreenIdentifier.ItemSlot.Offhand:
        var rightColumn = paperdollModule.find(".equipment-column:eq(2)");
        var offhandContainer = rightColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame.is-big:first"
        );
        offhandContainer.addClass("is-equipable");
        break;
      case CharacterScreenIdentifier.ItemSlot.Body:
        var middleColumn = paperdollModule.find(".equipment-column:eq(1)");
        var bodyArmorContainer = middleColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame.is-big:first"
        );
        bodyArmorContainer.addClass("is-equipable");
        break;
      case CharacterScreenIdentifier.ItemSlot.Ammo:
        var rightColumn = paperdollModule.find(".equipment-column:eq(2)");
        var ammoContainer = rightColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame:first"
        );
        ammoContainer.addClass("is-equipable");
        break;
      case CharacterScreenIdentifier.ItemSlot.Accessory:
        var leftColumn = paperdollModule.find(".equipment-column:first");
        var accessoryContainer = leftColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame:first"
        );
        accessoryContainer.addClass("is-equipable");
    }

    // if the item is not a head or armor piece, the item can go in the bag slots
    if (sourceData.isAllowedInBag) {
      $("div.l-backpack-row div.paperdoll-item.has-slot-frame").addClass(
        "is-equipable"
      );
    }

    /*
        console.info(sourceData);
        console.info(proxyData);
        */
  };

  result.Container.assignListItemDragAndDrop(
    _screenDiv,
    dragStartHandler,
    dragEndHandler,
    dropHandler
  );

  // add event handler
  result.Container.assignPaperdollItemRightClick(function (_item, _event) {
    var data = _item.data("item");

    var isEmpty = data !== null && "isEmpty" in data ? data.isEmpty : true;
    var itemId = data !== null && "itemId" in data ? data.itemId : null;
    //var itemIdx = (data !== null && 'index' in data) ? data.index : null;
    var entityId = data !== null && "entityId" in data ? data.entityId : null;
    var dropIntoInventory =
      KeyModiferConstants.CtrlKey in _event &&
      _event[KeyModiferConstants.CtrlKey] === true;
    var repairItem =
      KeyModiferConstants.AltKey in _event &&
      _event[KeyModiferConstants.AltKey] === true;

    if (
      isEmpty === false &&
      itemId !== null &&
      entityId !== null /*&& itemIdx !== null*/
    ) {
      // equip or drop into inventory
      if (repairItem === true) {
        self.mDataSource.toggleInventoryItem(itemId, entityId, function (ret) {
          data["repair"] = ret["repair"];
          data["salvage"] = ret["salvage"];
          result.setRepairImageVisible(data["repair"], data["salvage"]);
          //result.setSalvageImageVisible(data['salvage']);
        });
      } else if (dropIntoInventory === true) {
        //console.info('drop item into inventory: ' + itemId);
        self.mDataSource.dropPaperdollItem(entityId, itemId, null);
      } else {
        //console.info('equip item: ' + itemId);
        self.mDataSource.equipBagItem(entityId, itemId, null);
      }

      self.mDataSource.getInventoryModule().updateSlotsLabel();
    }
  });

  return result;
};

CharacterScreenPaperdollModule.prototype.createEquipmentSlot = function (
  _slot,
  _parentDiv,
  _screenDiv
) {
  var self = this;

  var layout = $(
    '<div class="l-slot-container ' + _slot.ContainerClasses + '"/>'
  );
  _parentDiv.append(layout);

  _slot.Container = layout.createPaperdollItem(
    _slot.ContainerIsBig,
    _slot.BackgroundImage
  );

  // update item data
  var itemData = _slot.Container.data("item");
  itemData.owner = CharacterScreenIdentifier.ItemOwner.Paperdoll;
  itemData.slotType = _slot.SlotType;

  // add event handler
  var dropHandler = function (_source, _target, _proxy) {
    //var sourceData = _source.data('item');
    var sourceData = _proxy.data("item");
    var targetData = _target.data("item");

    var sourceOwner =
      sourceData !== null && "owner" in sourceData ? sourceData.owner : null;
    var targetOwner =
      targetData !== null && "owner" in targetData ? targetData.owner : null;

    // dont allow drop animation just yet
    sourceData.isAllowedToDrop = false;
    _proxy.data("item", sourceData);

    if (sourceOwner === null || targetOwner === null) {
      console.info("Failed to drop item. Owners are invalid.");
      return;
    }

    // we don't allow swapping within the paperdoll
    if (sourceOwner === targetOwner) {
      //console.error('Failed to drop item. Owners are equal.');
      return;
    }

    if (sourceOwner === CharacterScreenIdentifier.ItemOwner.Ground) {
      // bullshit hack, fuck you imp
      $(".is-equipable").each(function () {
        $(this).removeClass("is-equipable");
      });
    }

    var entityId =
      sourceData !== null && "entityId" in sourceData ?
      sourceData.entityId :
      null;
    var itemId =
      sourceData !== null && "itemId" in sourceData ? sourceData.itemId : null;

    // we only allow equipping items with the same slot type
    var sourceSlotType =
      sourceData !== null && "slotType" in sourceData ?
      sourceData.slotType :
      null;
    var targetSlotType =
      targetData !== null && "slotType" in targetData ?
      targetData.slotType :
      null;
    var sourceItemId =
      sourceData !== null && "itemId" in sourceData ? sourceData.itemId : null;
    var sourceItemIdx =
      sourceData !== null && "index" in sourceData ? sourceData.index : null;
    var sourceIsBlockingOffhand =
      sourceData !== null && "isBlockingOffhand" in sourceData ?
      sourceData.isBlockingOffhand :
      false;
    var targetIsBlockingOffhand =
      targetData !== null && "isBlockingOffhand" in targetData ?
      targetData.isBlockingOffhand :
      false;
    var isUsable =
      sourceData !== null && "isUsable" in sourceData ? sourceData.isUsable : 0;

    /*
         console.info('sourceType: ' + sourceSlotType);
         console.info('targetType: ' + targetSlotType);

         console.info('sourceIsBlockingOffhand: ' + sourceIsBlockingOffhand);
         console.info('targetIsBlockingOffhand: ' + targetIsBlockingOffhand);
         */

    if (sourceItemIdx === null) {
      console.error("Failed to drop item. Source idx is invalid. #1");
      return;
    }

    // from Backpack -> Paperdoll
    if (sourceOwner === CharacterScreenIdentifier.ItemOwner.Backpack) {
      if (
        sourceData.isAllowedInBag === false ||
        targetData.isAllowedInBag === false
      ) {
        console.info("Paperdoll::dropHandler: Not allowed in bag!");
        return;
      }

      // check conditions
      var ignoreSlotType = false;

      // Special Case: Source = Twohander and Target = Offhand and Inventory = Stash and Main & Offhand are filled with Item and Stash = full
      if (
        sourceSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand &&
        sourceIsBlockingOffhand === true &&
        (targetSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand ||
          targetSlotType === CharacterScreenIdentifier.ItemSlot.Offhand)
      ) {
        if (
          self.mDataSource.hasItemEquipped(
            CharacterScreenIdentifier.ItemSlot.Mainhand
          ) &&
          self.mDataSource.hasItemEquipped(
            CharacterScreenIdentifier.ItemSlot.Offhand
          ) &&
          self.mDataSource.isBagSpaceLeft(1) === false
        ) {
          console.info("Paperdoll::dropHandler: Not enough bag space!");
          return;
        }

        ignoreSlotType = true;
      }

      // Same Slot type ?
      if (ignoreSlotType === false && targetSlotType !== null) {
        if (sourceSlotType !== targetSlotType) {
          console.info(
            "Paperdoll::dropHandler: Item must be the same slot type!"
          );
          return;
        }
      }

      // enough APs ?
      if (self.mDataSource.hasEnoughAPToEquip() === false) {
        console.info("Paperdoll::dropHandler: Not enough Action points!");
        return;
      }

      // allow drop animation
      sourceData.isAllowedToDrop = true;
      _proxy.data("item", sourceData);

      console.info(
        "Backpack -> Paperdoll (sourceItemIdx: " + sourceItemIdx + ")"
      );
      self.mDataSource.equipBagItem(entityId, sourceItemId, sourceItemIdx);

      return;
    }

    // from Stash | Ground -> Paperdoll | Backpack
    if (
      sourceOwner === CharacterScreenIdentifier.ItemOwner.Stash ||
      sourceOwner === CharacterScreenIdentifier.ItemOwner.Ground
    ) {
      // NOTE: (js) check conditions
      var ignoreSlotType = false;

      // Special Case: Source = Twohander and Target = Offhand and Inventory = Stash and Main & Offhand are filled with Item and Stash = full
      if (
        sourceSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand &&
        sourceIsBlockingOffhand === true &&
        (targetSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand ||
          targetSlotType === CharacterScreenIdentifier.ItemSlot.Offhand)
      ) {
        if (
          self.mDataSource.hasItemEquipped(
            CharacterScreenIdentifier.ItemSlot.Mainhand
          ) &&
          self.mDataSource.hasItemEquipped(
            CharacterScreenIdentifier.ItemSlot.Offhand
          ) &&
          self.mDataSource.isInStashMode() === true &&
          self.mDataSource.isStashSpaceLeft(2) === false
        ) {
          console.info("Paperdoll::dropHandler: Not enough stash space!");
          return;
        }

        ignoreSlotType = true;
      }

      // Same Slot type ?
      if (ignoreSlotType === false && targetSlotType !== null) {
        if (sourceSlotType !== targetSlotType && !isUsable) {
          console.info("isUsable = " + isUsable);
          console.info(
            "Paperdoll::dropHandler: Item must be the same slot type!"
          );
          return;
        }
      }

      // enough APs ?
      if (self.mDataSource.hasEnoughAPToEquip() === false) {
        console.info("Paperdoll::dropHandler: Not enough Action points!");
        return;
      }

      // Ground mode and Armor slot ?
      if (
        self.mDataSource.isInGroundMode() === true &&
        (sourceSlotType === CharacterScreenIdentifier.ItemSlot.Head ||
          sourceSlotType === CharacterScreenIdentifier.ItemSlot.Body)
      ) {
        console.info("Paperdoll::dropHandler: #3");
        return;
      }

      // allow drop animation
      sourceData.isAllowedToDrop = true;
      _proxy.data("item", sourceData);

      // all fine - drop this shit
      //console.info('Stash | Ground -> Paperdoll');
      self.mDataSource.equipInventoryItem(entityId, itemId, sourceItemIdx);
    }
  };

  var dragEndHandler = function (_source, _target, _proxy) {
    $(".is-equipable").each(function () {
      $(this).removeClass("is-equipable");
    });

    if (_source.length === 0 || _target.length === 0) {
      return false;
    }

    //var sourceData = _source.data('item');
    var sourceData = _proxy.data("item");
    var targetData = _target.data("item");

    var isAllowedToDrop =
      sourceData !== null &&
      "isAllowedToDrop" in sourceData &&
      targetData !== undefined &&
      targetData !== null ?
      sourceData.isAllowedToDrop :
      false;
    if (isAllowedToDrop === false) {
      console.info(
        "Paperdoll::dragEndHandler: Failed to drop item. Not allowed."
      );
      return false;
    }

    var sourceOwner =
      sourceData !== null && "owner" in sourceData ? sourceData.owner : null;
    var targetOwner =
      targetData !== null && "owner" in targetData ? targetData.owner : null;
    var hasTargetIndex =
      targetData !== null && "index" in targetData && targetData.index !== null;
    var isEmpty =
      targetData !== null && "isEmpty" in targetData ?
      targetData.isEmpty :
      true;

    /*
                if (sourceOwner === null || targetOwner === null)
                {
                    console.error('Failed to drop item. Owner are invalid.');
                    return false;
                }
        */

    /*
        // we don't allow swapping within the paperdoll
        if (sourceOwner === targetOwner)
        {
            //console.error('Failed to drop item. Owners are equal.');
            return false;
        }

        // we only allow equipping items with the same slot type
        var sourceSlotType = (sourceData !== null && 'slotType' in sourceData) ? sourceData.slotType : null;
        var targetSlotType = (targetData !== null && 'slotType' in targetData) ? targetData.slotType : null;
        var sourceIsBlockingOffhand = (sourceData !== null && 'isBlockingOffhand' in sourceData) ? sourceData.isBlockingOffhand : false;
        var targetIsBlockingOffhand = (targetData !== null && 'isBlockingOffhand' in targetData) ? targetData.isBlockingOffhand : false;

        if (sourceSlotType === null || (isEmpty !== true && targetSlotType === null))
        {
            console.error('Failed to drop item. Slot types not assigned.');
            return false;
        }

        // special case for checking same slot types
        if (isEmpty !== true)
        {
            if (sourceSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand || sourceSlotType === CharacterScreenIdentifier.ItemSlot.Offhand)
            {
                //console.info('#1');

                if (sourceSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand)
                {
                    if ((sourceIsBlockingOffhand === false && self.mDataSource.hasItemEquipped(CharacterScreenIdentifier.ItemSlot.Offhand)) &&
                        (targetSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand && targetIsBlockingOffhand === true)
                        )
                    {
                        //console.info('#1.1');
                        return false;
                    }

                    if ((sourceSlotType === CharacterScreenIdentifier.ItemSlot.Mainhand && sourceIsBlockingOffhand === true) &&
                        targetSlotType === CharacterScreenIdentifier.ItemSlot.Offhand
                        )
                    {
                        //console.info('#4');
                        return true;
                    }

                    // same slot type?
                    if (sourceSlotType !== targetSlotType)
                    {
                        //console.info('#1.2');
                        return false;
                    }
                }
                else
                {
                    if (targetSlotType !== CharacterScreenIdentifier.ItemSlot.Offhand)
                    {
                        //console.info('#1.3');
                        return false;
                    }
                }
            }
            else
            {
                //console.info('#2');

                // same slot type?
                if (sourceSlotType !== targetSlotType)
                {
                    console.error('Failed to drop item. Slot types have to be the same. #1');
                    return false;
                }
            }

            return true;
        }
        */

    // we don't allow swapping if there is not enough space left
    if (
      sourceOwner === CharacterScreenIdentifier.ItemOwner.Stash &&
      !hasTargetIndex
    ) {
      console.info("Failed to drop item. Stash is full.");
      return self.mDataSource.isStashSpaceLeft();
    }

    self.mDataSource.getInventoryModule().updateSlotsLabel();

    return true;
  };

  var dragStartHandler = function (_source, _proxy) {
    var paperdollModule = $(".paperdoll-module");

    if (_source.length === 0) {
      return false;
    }

    //var sourceData = _source.data('item');
    var sourceData = _proxy.data("item");
    //var proxyData = _source.data('item');
    var sourceSlotType =
      sourceData !== null && "slotType" in sourceData ?
      sourceData.slotType :
      null;
    //console.log("Source data: " + sourceSlotType);

    switch (sourceSlotType) {
      case CharacterScreenIdentifier.ItemSlot.Mainhand:
        var leftColumn = paperdollModule.find(".equipment-column:first");
        var mainhandContainer = leftColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame.is-big:first"
        );
        mainhandContainer.addClass("is-equipable");
        break;
      case CharacterScreenIdentifier.ItemSlot.Head:
        var middleColumn = paperdollModule.find(".equipment-column:eq(1)");
        var headContainer = middleColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame:first"
        );
        headContainer.addClass("is-equipable");
        break;
      case CharacterScreenIdentifier.ItemSlot.Offhand:
        var rightColumn = paperdollModule.find(".equipment-column:eq(2)");
        var offhandContainer = rightColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame.is-big:first"
        );
        offhandContainer.addClass("is-equipable");
        break;
      case CharacterScreenIdentifier.ItemSlot.Body:
        var middleColumn = paperdollModule.find(".equipment-column:eq(1)");
        var bodyArmorContainer = middleColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame.is-big:first"
        );
        bodyArmorContainer.addClass("is-equipable");
        break;
      case CharacterScreenIdentifier.ItemSlot.Ammo:
        var rightColumn = paperdollModule.find(".equipment-column:eq(2)");
        var ammoContainer = rightColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame:first"
        );
        ammoContainer.addClass("is-equipable");
        break;
      case CharacterScreenIdentifier.ItemSlot.Accessory:
        var leftColumn = paperdollModule.find(".equipment-column:first");
        var accessoryContainer = leftColumn.find(
          ".ui-control.paperdoll-item.has-slot-frame:first"
        );
        accessoryContainer.addClass("is-equipable");
    }

    // if the item is not a head or armor piece, the item can go in the bag slots
    if (sourceData.isAllowedInBag) {
      $("div.l-backpack-row div.paperdoll-item.has-slot-frame").addClass(
        "is-equipable"
      );
    }

    /*
        console.info(sourceData);
        console.info(proxyData);
        */
  };

  // add event handler
  _slot.Container.assignPaperdollItemDragAndDrop(
    _screenDiv,
    dragStartHandler,
    dragEndHandler,
    dropHandler
  );

  _slot.Container.assignPaperdollItemRightClick(function (_item, _event) {
    var data = _item.data("item");

    var isEmpty = data !== null && "isEmpty" in data ? data.isEmpty : true;
    var itemId = data !== null && "itemId" in data ? data.itemId : null;
    //var itemIdx = (data !== null && 'index' in data) ? data.index : null;
    var entityId = data !== null && "entityId" in data ? data.entityId : null;
    var dropIntoInventory =
      KeyModiferConstants.CtrlKey in _event &&
      _event[KeyModiferConstants.CtrlKey] === true;
    var repairItem =
      KeyModiferConstants.AltKey in _event &&
      _event[KeyModiferConstants.AltKey] === true;

    if (
      isEmpty === false &&
      itemId !== null &&
      entityId !== null /*&& itemIdx !== null*/
    ) {
      if (repairItem === true) {
        self.mDataSource.toggleInventoryItem(itemId, entityId, function (ret) {
          data["repair"] = ret["repair"];
          data["salvage"] = ret["salvage"];
          _slot.Container.setRepairImageVisible(
            data["repair"],
            data["salvage"]
          );
          //result.setSalvageImageVisible(data['salvage']);
        });
      }
      // equip or drop in bag
      else if (dropIntoInventory === true) {
        //console.info('drop item: ' + itemId);
        self.mDataSource.dropPaperdollItem(entityId, itemId, null);
      } else if (data.isAllowedInBag === true) {
        //console.info('drop item into bag: ' + itemId);
        self.mDataSource.dropPaperdollItemIntoBag(entityId, itemId, null);
      }

      self.mDataSource.getInventoryModule().updateSlotsLabel();
    }
  });
};

CharacterScreenPaperdollModule.prototype.removeItemFromSlot = function (_slot) {
  _slot.Container.assignPaperdollItemImage();
  _slot.Container.assignPaperdollItemOverlayImage();
  _slot.Container.setPaperdollRepairImageVisible(false);
};

CharacterScreenPaperdollModule.prototype.clearItems = function () {
  var self = this;
  $.each(this.mLeftEquipmentSlots, function (_key, _value) {
    self.removeItemFromSlot(_value);
  });

  $.each(this.mMiddleEquipmentSlots, function (_key, _value) {
    self.removeItemFromSlot(_value);
  });

  $.each(this.mRightEquipmentSlots, function (_key, _value) {
    self.removeItemFromSlot(_value);
  });

  this.mUpgradeButtons.forEach(function (btn, index) {
    btn.unbindTooltip();
  });

  this.mHelmetUpgradeButtons.forEach(function (btn, index) {
    btn.unbindTooltip();
  });

};

CharacterScreenPaperdollModule.prototype.assignItemToSlot = function (
  _slot,
  _entityId,
  _item,
  _isBlocked
) {
  // remove item?
  if (
    _item === null ||
    !(CharacterScreenIdentifier.Item.Id in _item) ||
    !(CharacterScreenIdentifier.Item.ImagePath in _item)
  ) {
    _slot.Container.assignPaperdollItemImage();
    _slot.Container.assignPaperdollItemOverlayImage();

    // update item data
    var itemData = _slot.Container.data("item") || {};
    itemData.itemId = null;
    itemData.slotType = null;
    itemData.entityId = null;
    itemData.isChangeableInBattle = null;
    itemData.isBlockingOffhand = null;
    itemData.isAllowedInBag = null;
    _slot.Container.data("item", itemData);
    _slot.Container.setPaperdollRepairImageVisible(false);
  } else {
    var isSlotBlocked = _isBlocked !== undefined && _isBlocked === true;

    // update item data
    var itemData = _slot.Container.data("item") || {};
    itemData.itemId = _item[CharacterScreenIdentifier.Item.Id];

    // set slot type correctly to offhand if the mainhand is a twohander
    itemData.slotType =
      isSlotBlocked === true &&
      _item[CharacterScreenIdentifier.Item.Slot] ===
      CharacterScreenIdentifier.ItemSlot.Mainhand ?
      CharacterScreenIdentifier.ItemSlot.Offhand :
      _item[CharacterScreenIdentifier.Item.Slot];
    itemData.entityId = _entityId;
    itemData.isChangeableInBattle =
      CharacterScreenIdentifier.ItemFlag.IsChangeableInBattle in _item &&
      _item[CharacterScreenIdentifier.ItemFlag.IsChangeableInBattle] === true;
    itemData.isBlockingOffhand =
      CharacterScreenIdentifier.ItemFlag.IsBlockingOffhand in _item ?
      _item[CharacterScreenIdentifier.ItemFlag.IsBlockingOffhand] :
      false;
    itemData.isAllowedInBag = _item.isAllowedInBag;
    itemData.isUsable = _item.isUsable;
    _slot.Container.data("item", itemData);

    // check size
    var isSmall = false;
    if (
      !(CharacterScreenIdentifier.ItemFlag.IsBagSlot in _slot) ||
      _slot[CharacterScreenIdentifier.ItemFlag.IsBagSlot] === false
    ) {
      if (
        CharacterScreenIdentifier.ItemFlag.IsLarge in _item &&
        _item[CharacterScreenIdentifier.ItemFlag.IsLarge] === false
      ) {
        isSmall = _slot.ContainerIsBig;
      }
    }

    _slot.Container.assignPaperdollItemImage(
      Path.ITEMS + _item[CharacterScreenIdentifier.Item.ImagePath],
      isSmall,
      isSlotBlocked
    );
    _slot.Container.assignPaperdollItemOverlayImage(
      _item["imageOverlayPath"],
      isSmall,
      isSlotBlocked
    );

    // show amount
    if (
      !_isBlocked &&
      _item["showAmount"] === true &&
      _item[CharacterScreenIdentifier.Item.Amount] != ""
    ) {
      _slot.Container.assignPaperdollItemAmount(
        "" + _item[CharacterScreenIdentifier.Item.Amount],
        _item[CharacterScreenIdentifier.Item.AmountColor]
      );
    }

    // show repair icon?
    _slot.Container.setPaperdollRepairImageVisible(
      _item["repair"] && this.mDataSource.isInStashMode()
    );

    // bind tooltip to image layer
    _slot.Container.assignPaperdollItemTooltip(
      _item[CharacterScreenIdentifier.Item.Id],
      TooltipIdentifier.ItemOwner.Entity,
      _entityId
    );
  }
};

CharacterScreenPaperdollModule.prototype.showSlotLock = function (
  _slot,
  _showLock
) {
  _slot.Container.showPaperdollLockedImage(_showLock);
};

CharacterScreenPaperdollModule.prototype.updateSlotLocks = function (
  _inventoryMode
) {
  switch (_inventoryMode) {
    case CharacterScreenDatasourceIdentifier.InventoryMode.Stash:
    case CharacterScreenDatasourceIdentifier.InventoryMode.BattlePreparation: {
      this.showSlotLock(this.mMiddleEquipmentSlots.Head, false);
      this.showSlotLock(this.mMiddleEquipmentSlots.Body, false);
    }
    break;
  case CharacterScreenDatasourceIdentifier.InventoryMode.Ground: {
    this.showSlotLock(this.mMiddleEquipmentSlots.Head, true);
    this.showSlotLock(this.mMiddleEquipmentSlots.Body, true);
  }
  break;
  }
};

CharacterScreenPaperdollModule.prototype.clearBags = function () {
  for (var i = 0; i < this.mBackpackSlots.length; ++i) {
    this.removeItemFromSlot(this.mBackpackSlots[i]);
  }
};

CharacterScreenPaperdollModule.prototype.showBags = function (_numberOfBags) {
  if (_numberOfBags < 0 || _numberOfBags > Constants.Game.MAX_BACKPACK_SLOTS) {
    console.error(
      "ERROR: Failed to show paperdoll bags. Invalid number of bags."
    );
    return;
  }

  var backpackRowLayout = this.mContainer.find(".l-backpack-row:first");
  if (backpackRowLayout.length > 0) {
    for (var i = 0; i < Constants.Game.MAX_BACKPACK_SLOTS; ++i) {
      backpackRowLayout.removeClass("has-slot-" + (i + 1));

      if (i < _numberOfBags) {
        this.mBackpackSlots[i].Container.parent()
          .removeClass("display-none")
          .addClass("display-block");
      } else {
        this.mBackpackSlots[i].Container.parent()
          .removeClass("display-block")
          .addClass("display-none");
      }
    }

    backpackRowLayout.addClass("has-slot-" + _numberOfBags);
  }
};

CharacterScreenPaperdollModule.prototype.registerDatasourceListener = function () {
  this.mDataSource.addListener(
    ErrorCode.Key,
    jQuery.proxy(this.onDataSourceError, this)
  );

  this.mDataSource.addListener(
    CharacterScreenDatasourceIdentifier.Brother.Updated,
    jQuery.proxy(this.onBrotherUpdated, this)
  );
  this.mDataSource.addListener(
    CharacterScreenDatasourceIdentifier.Brother.Selected,
    jQuery.proxy(this.onBrotherSelected, this)
  );

  this.mDataSource.addListener(
    CharacterScreenDatasourceIdentifier.Inventory.ModeUpdated,
    jQuery.proxy(this.onInventoryModeUpdated, this)
  );
};

CharacterScreenPaperdollModule.prototype.create = function (_parentDiv) {
  this.createDIV(_parentDiv);
};

CharacterScreenPaperdollModule.prototype.destroy = function () {
  this.destroyDIV();
};

CharacterScreenPaperdollModule.prototype.register = function (_parentDiv) {
  console.log("CharacterScreenPaperdollModule::REGISTER");

  if (this.mContainer !== null) {
    console.error(
      "ERROR: Failed to register Paperdoll Module. Reason: Module is already initialized."
    );
    return;
  }

  if (_parentDiv !== null && typeof _parentDiv == "object") {
    this.create(_parentDiv);
  }
};

CharacterScreenPaperdollModule.prototype.unregister = function () {
  console.log("CharacterScreenPaperdollModule::UNREGISTER");

  if (this.mContainer === null) {
    console.error(
      "ERROR: Failed to unregister Paperdoll Module. Reason: Module is not initialized."
    );
    return;
  }

  this.destroy();
};

CharacterScreenPaperdollModule.prototype.isRegistered = function () {
  if (this.mContainer !== null) {
    return this.mContainer.parent().length !== 0;
  }

  return false;
};

CharacterScreenPaperdollModule.prototype.assignEquipment = function (
  _brotherId,
  _data
) {
  var blockOffhand = false;
  var self = this;
  if (CharacterScreenIdentifier.ItemSlot.Mainhand in _data) {
    var mainHand = _data[CharacterScreenIdentifier.ItemSlot.Mainhand];
    blockOffhand =
      CharacterScreenIdentifier.ItemFlag.IsBlockingOffhand in mainHand &&
      mainHand[CharacterScreenIdentifier.ItemFlag.IsBlockingOffhand] === true;

    this.assignItemToSlot(
      this.mLeftEquipmentSlots.RightHand,
      _brotherId,
      mainHand
    );

    // add weapon to offhand as semi transparent image
    if (blockOffhand) {
      this.assignItemToSlot(
        this.mRightEquipmentSlots.LeftHand,
        _brotherId,
        mainHand,
        true
      );
    }
  }

  if (
    blockOffhand !== true &&
    CharacterScreenIdentifier.ItemSlot.Offhand in _data
  ) {
    this.assignItemToSlot(
      this.mRightEquipmentSlots.LeftHand,
      _brotherId,
      _data[CharacterScreenIdentifier.ItemSlot.Offhand]
    );
  }


  var _upgrades = [];
  if (CharacterScreenIdentifier.ItemSlot.Head in _data) {
    this.assignItemToSlot(
      this.mMiddleEquipmentSlots.Head,
      _brotherId,
      _data[CharacterScreenIdentifier.ItemSlot.Head]
    );

    _upgrades = _data[CharacterScreenIdentifier.ItemSlot.Head]["upgrades"]
  }

  this.mHelmetUpgradeButtons.forEach(function (btn, index) {
    var enabled = false;
    var text = "X";
    if (_upgrades !== undefined && _upgrades !== '' && _upgrades.length > 0) {
      var tLabel = index + 1;
      if (tLabel === 4) {
        tLabel = "R";
      } else if (tLabel === 5)
      {
        tLabel = "3"
      }
      switch (_upgrades[index]) {
        case 0:
          text = "" + tLabel;
          break;
        case 1:
          text = "" + tLabel;
          enabled = self.mDataSource.isTacticalMode() === true ? false : true;
          break;
      }
    }
    btn.changeButtonText(text);
    btn.enableButton(enabled);
    btn.bindTooltip({
      contentType: 'ui-item',
      entityId: _brotherId,
      itemId: index,
      itemOwner: 'paperdoll.remove-helmet-layer'
    });
  });

  _upgrades = [];
  if (CharacterScreenIdentifier.ItemSlot.Body in _data) {
    this.assignItemToSlot(
      this.mMiddleEquipmentSlots.Body,
      _brotherId,
      _data[CharacterScreenIdentifier.ItemSlot.Body]
    );

    //Setup the armor layers enable buttons
    _upgrades = _data[CharacterScreenIdentifier.ItemSlot.Body]["upgrades"]
  }

  this.mUpgradeButtons.forEach(function (btn, index) {
    var enabled = false;
    var text = "X";
    if (_upgrades !== undefined && _upgrades !== '' && _upgrades.length > 0) {
      var tLabel = index + 1;
      if (tLabel === 6) {
        tLabel = "R";
      }
      switch (_upgrades[index]) {
        case 0:
          text = "" + tLabel;
          break;
        case 1:
          text = "" + tLabel;
          enabled = self.mDataSource.isTacticalMode() === true ? false : true;
          break;
      }
    }
    btn.changeButtonText(text);
    btn.enableButton(enabled);
    btn.bindTooltip({
      contentType: 'ui-item',
      entityId: _brotherId,
      itemId: index,
      itemOwner: 'paperdoll.remove-armor-layer'
    });
  });


  if (CharacterScreenIdentifier.ItemSlot.Accessory in _data) {
    this.assignItemToSlot(
      this.mLeftEquipmentSlots.Accessory,
      _brotherId,
      _data[CharacterScreenIdentifier.ItemSlot.Accessory]
    );
  }

  if (CharacterScreenIdentifier.ItemSlot.Ammo in _data) {
    this.assignItemToSlot(
      this.mRightEquipmentSlots.Ammo,
      _brotherId,
      _data[CharacterScreenIdentifier.ItemSlot.Ammo]
    );
  }
};

CharacterScreenPaperdollModule.prototype.assignBags = function (
  _brotherId,
  _data
) {
  if (jQuery.isArray(_data) && _data.length !== null) {
    var numBags =
      _data.length > Constants.Game.MAX_BACKPACK_SLOTS ?
      Constants.Game.MAX_BACKPACK_SLOTS :
      _data.length;
    this.showBags(numBags);

    for (var i = 0; i < numBags; ++i) {
      this.assignItemToSlot(this.mBackpackSlots[i], _brotherId, _data[i]);
    }
  }
};

CharacterScreenPaperdollModule.prototype.onBrotherUpdated = function (
  _dataSource,
  _brother
) {
  if (this.mDataSource.isSelectedBrother(_brother)) {
    this.onBrotherSelected(_dataSource, _brother);
  }
};

CharacterScreenPaperdollModule.prototype.blockThisSlot = function (_slot) {
  _slot.Container.assignPaperdollItemImage(_slot.BlockedImage, false, false);
  _slot.Container.assignPaperdollItemOverlayImage();
  _slot.Container.setPaperdollRepairImageVisible(false);
};

CharacterScreenPaperdollModule.prototype.assignBlockSlots = function (
  _brotherId,
  _data
) {
	if (_data[CharacterScreenIdentifier.ItemSlot.Mainhand])
	{
		this.blockThisSlot(this.mLeftEquipmentSlots.RightHand);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Offhand])
	{
		this.blockThisSlot(this.mRightEquipmentSlots.LeftHand);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Head])
	{
		this.blockThisSlot(this.mMiddleEquipmentSlots.Head);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Body])
	{
		this.blockThisSlot(this.mMiddleEquipmentSlots.Body);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Accessory])
	{
		this.blockThisSlot(this.mLeftEquipmentSlots.Accessory);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Ammo])
	{
		this.blockThisSlot(this.mRightEquipmentSlots.Ammo);
	}
  
	
};

CharacterScreenPaperdollModule.prototype.onBrotherSelected = function (
  _dataSource,
  _brother
) {
  if (_brother !== null && CharacterScreenIdentifier.Entity.Id in _brother) {
    this.clearItems();
    this.clearBags();

    if (CharacterScreenIdentifier.Paperdoll.Equipment in _brother) {
      this.assignEquipment(
        _brother[CharacterScreenIdentifier.Entity.Id],
        _brother[CharacterScreenIdentifier.Paperdoll.Equipment]
      );
    }
	
	if ('restriction' in _brother && _brother['restriction'] !== undefined && _brother['restriction'] !== null) {
       this.assignBlockSlots(
        _brother[CharacterScreenIdentifier.Entity.Id],
        _brother['restriction']
      );
    }

    if (CharacterScreenIdentifier.Paperdoll.Bag in _brother) {
      this.assignBags(
        _brother[CharacterScreenIdentifier.Entity.Id],
        _brother[CharacterScreenIdentifier.Paperdoll.Bag]
      );
    }
  }
};

CharacterScreenPaperdollModule.prototype.onInventoryModeUpdated = function (
  _dataSource,
  _mode
) {
  this.updateSlotLocks(_mode);
};

CharacterScreenPaperdollModule.prototype.onDataSourceError = function (
  _dataSource,
  _data
) {
  if (_data === undefined || _data === null || typeof _data !== "number") {
    return;
  }

  switch (
    _data
    /*
        case ErrorCode.NotEnoughStashSpace:
        {
            this.mSlotCountContainer.shakeLeftRight();
        } break;
        */
  ) {}

  console.info(
    "CharacterScreenPaperdollModule::onDataSourceError(" + _data + ")"
  );
};