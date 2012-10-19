/**
 Copyright 2011 Red Hat, Inc.

 This software is licensed to you under the GNU General Public
 License as published by the Free Software Foundation; either version
 2 of the License (GPLv2) or (at your option) any later version.
 There is NO WARRANTY for this software, express or implied,
 including the implied warranties of MERCHANTABILITY,
 NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
 have received a copy of GPLv2 along with this software; if not, see
 http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
*/
var filtertable = (function() {
    return {
        initialize : function() {

            if ( $('table.filter_table_hidden').length > 0 ){

                var theTable = $('table.filter_table');
                var theTableHidden = $('table.filter_table_hidden');
                var filter = $('#filter');
                var load_more = $('a#more');
                var load_summary = $('span#loaded_summary');

                filter.live('change, keyup', function(){
                    $.uiTableFilter(theTableHidden, this.value);
                    theTable.hide();
                    load_more.hide();
                    load_summary.hide();
                    theTableHidden.show();
                    if ( this.value == '' ) {
                        theTable.show();   
                        load_more.show();
                        load_summary.show();
                        theTableHidden.hide();
                    }
                });

            } else {
                var theTable = $('table.filter_table');
                var filter = $('#filter');

                filter.live('change, keyup', function(){
                $.uiTableFilter(theTable, this.value);
                });
            }

            //override the submit so it doesn't try to push a form
            $('#filter_form').submit(function () {
                filter.keyup();
                return false;
            }).focus(); //Give focus to input field
            $('.filter_button').click(function(){filter.change()});            

        }
    }
})();

$(document).ready(function() {
    // initialize the filter table
    filtertable.initialize();
});
