/*
* Copyright (c) 2017 Daniel Foré (http://danielfore.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

public class MainWindow : Gtk.Window {
    private const string CODE_STYLE = """
        .code {
            background-color: #fdf6e3;
            border-radius: 3px;
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.20);
            color: #657b83;
            font-family: roboto mono;
            padding: 6px;
        }

        .code:selected {
            background-color: #657B84;
            color: #fdf6e3;
        }
    """;

    public MainWindow (Gtk.Application application) {
        Object (application: application,
                icon_name: "com.github.danrabbit.lookbook",
                title: _("LookBook"),
                height_request: 600,
                width_request: 800);
    }

    construct {
        var categories = new Gtk.Stack ();

        var icon_theme = Gtk.IconTheme.get_default ();

        icon_theme.list_contexts ().foreach ((category) => {
            var category_view = new CategoryView (category);
            categories.add_titled (category_view, category, category);
        });

        var categories_sidebar = new Gtk.StackSidebar ();
        categories_sidebar.stack = categories;
        categories_sidebar.vexpand = true;

        var grid = new Gtk.Grid ();
        grid.add (categories_sidebar);
        grid.add (categories);

        add (grid);

        var provider = new Gtk.CssProvider ();
        try {
            provider.load_from_data (CODE_STYLE, CODE_STYLE.length);
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        } catch (Error e) {
            critical (e.message);
        }

        show_all ();
    }
}