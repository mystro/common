module Mystro
  module Common
    module Version
      MAJOR = 0
      MINOR = 3
      TINY = 1
      TAG = 'alpha1'
      LIST  = [MAJOR, MINOR, TINY, TAG]
      STRING = LIST.compact.join(".")
    end
  end
end