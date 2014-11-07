local Config = {}

-- Colors are "AARRGGBB"
local ApolloColor = ApolloColor
Config.Colors = {
  red      = ApolloColor.new("ffc83900"), -- bomb
  cyan     = ApolloColor.new("ff188794"), -- ghost
  green    = ApolloColor.new("ff2ec017"), -- mask
  purple   = ApolloColor.new("ff9877ff"), -- octopus
  pink     = ApolloColor.new("ffd65a66"), -- piggy
  golden   = ApolloColor.new("ffb47900"), -- cock
  gray     = ApolloColor.new("ffb2b1ad"), -- toaster
  blue     = ApolloColor.new("ff083edb"), -- spaceship
  yellow   = ApolloColor.new("ffffff00"),
  white    = ApolloColor.new("ffffffff")
}


Config.Encounters = {
  ['Weak Target Dummy'] = {
    ['Buff'] = {
      ['Bolster'] = "GeneticAssistSprites:EssenceRot"
    },
    ['Cast'] = {
      ['Repulse Field'] = 'GeneticAssistSprites:GeneticConsumption'
    },
    ['Line'] = {
      ['Thickness'] = 5,
      ['Color'] = Config.Colors.white
    },
    ['Marker'] = {
      ['Sprite'] = 'GeneticAssistSprites:Egg',
      ['Color'] = Config.Colors.white,
      ['Width'] = 48,
      ['Height'] = 48
    },
    ['Circle'] = {
      ['Resolution'] = 18,
      ['Thickness'] = 4,
      ['Color'] = Config.Colors.yellow,
      ['Height'] = 1,
      ['Outline'] = true,
      ['Radius'] = 5
    },
    ['SkipCombatCheck'] = false
  },

  -- [✓] MINIBOSS: Genetic Monstrosity
  ['Pustule'] = {
    ['Marker'] = {
      ['Sprite'] = 'GeneticAssistSprites:Egg',
      ['Color'] = Config.Colors.white,
      ['Width'] = 48,
      ['Height'] = 48
    },
    ['SkipCombatCheck'] = true
  },

  -- [  ] MINIBOSS: Hideous Malformed Mutant
  ['Hideous Malformed Mutant'] = {
    ['Cast'] = {
      ['Genetic Consumption'] = 'GeneticAssistSprites:GeneticConsumption'
    }
  },

  -- [✓] MINIBOSS: Gravitron Operator
  ['Anti-Gravity Bubble'] = {
    ['SkipCombatCheck'] = true,
    ['Notification'] = 'GeneticAssistSprites:Bubble',
    ['Line'] = {
      ['Thickness'] = 5,
      ['Color'] = Config.Colors.white
    }
  },

  -- [✓] MINIBOSS: Fetid Miscreation
  ['Fetid Miscreation'] = {
    ['Cast'] = {
      ['Genetic Decomposition'] = 'GeneticAssistSprites:GeneticDecomposition'
    }
  },

  -- MINIBOSS: Guardians
  -- Pillars

  -- [✓] BOSS: Phagetech Guardians
  -- Malicious Link ~ Notification
  ['Phagetech Commander'] = {
    ['Cast'] = {
      ['Forced Production'] = 'GeneticAssistSprites:ForcedProduction'
    }
  },
  ['Phagetech Augmentor'] = {
    ['Cast'] = {
      ['Summon Repairbot'] = 'GeneticAssistSprites:SummonRepairBot'
    }
  },
  ['Phagetech Fabricator'] = {
    ['Cast'] = {
      ['Summon Destructobot'] = 'GeneticAssistSprites:SummonDestructoBots'
    }
  },
  ['Phagetech Protector'] = {
    ['Cast'] = {
      ['Defensive Translocation'] = 'GeneticAssistSprites:Translocate'
    }
  },
  ['Destructo Contruct X'] = {
    ['Line'] = {
      ['Thickness'] = 5,
      ['Color'] = Config.Colors.white
    },
    ['Marker'] = {
      ['Sprite'] = 'GeneticAssistSprites:Poison',
      ['Color'] = Config.Colors.white,
      ['Width'] = 64,
      ['Height'] = 64
    }
  },
  ['Maintenance Construct C-5'] = {
    ['Line'] = {
      ['Thickness'] = 5,
      ['Color'] = Config.Colors.white
    },
    ['Marker'] = {
      ['Sprite'] = 'GeneticAssistSprites:Potion',
      ['Color'] = Config.Colors.white,
      ['Width'] = 64,
      ['Height'] = 64
    }
  },

  -- BOSS: PhageMaw
  -- ['Phagemaw'] = { },
  ['Detonation Bomb'] = {
    ['Line'] = {
      ['Thickness'] = 5,
      ['Color'] = Config.Colors.white
    },
    ['Marker'] = {
      ['Sprite'] = 'GeneticAssistSprites:Bomb',
      ['Color'] = Config.Colors.white,
      ['Width'] = 36,
      ['Height'] = 36
    }
  },
  -- Batteries ~ Icon
  -- Reactors ~ Numbered 1-3 (or count down the number left and give each a different color)
  -- Shield ~ "You've Been Choosen" Notification & Sound Effect



  -----------
  -- TRASH --
  -----------

  ['Corrupted Experimental Abomination'] = {
    ['Cast'] = {
      ['Genetic Enhancement'] = 'GeneticAssistSprites:GeneticEnhancement'
    }
  },

  ['Plague Breeder'] = {
    ['Cast'] = {
      ['Empowering Corruption'] = 'GeneticAssistSprites:EmpoweringCorruption'
    }
  },

  ['Phageborn Brute'] = {
    ['Cast'] = {
      ['Beatdown'] = 'GeneticAssistSprites:Beatdown'
    }
  }
}

Apollo.RegisterPackage(Config, "GeneticAssist:Config", 1, {})