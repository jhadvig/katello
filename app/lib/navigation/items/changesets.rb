#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

module Navigation
  module Items
    class Changesets < Navigation::Item

      def initialize(organization)
        @key           = :changesets
        @display       = _("Changesets")
        @authorization = lambda{ organization && KTEnvironment.any_viewable_for_promotions?(organization) }
        @url           = promotions_path
      end

    end
  end
end
