# -*- encoding : utf-8 -*-
class System::Constant
  PICK_OPTIONS = Hash.new([:sum_tags, :multi_option_tags])
  PICK_OPTIONS[Seed::ActivitySituationReport] = [:sum_tags]
  PICK_OPTIONS[Seed::ActivationReport] = [:sum_tags, :multi_option_tags, :partner_tags]
  PICK_OPTIONS[Seed::SeedApkMd5Alarm] = []

end
