module Mystro
  module Common
    module Version
      MAJOR = 0
      MINOR = 3
      TINY = 3
      TAG = nil
      LIST  = [MAJOR, MINOR, TINY, TAG]
      STRING = LIST.compact.join(".")
    end
  end
end