//
//  vanjacloudmacApp.swift
//  vanjacloudmac
//
//  Created by Vanja Oljaca on 1/31/23.
//

import SwiftUI
import NotionSwift

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    @IBOutlet weak var popover: NSPopover!


    func applicationDidFinishLaunching(_ notification: Notification) {

        return
                // https://gist.github.com/othyn/98f35abf988bdcfb6a118b8573d46b3b
                // https://khorbushko.github.io/article/2021/04/30/minimal-macOS-menu-bar-extra's-app-with-SwiftUI.html
                //https://stackoverflow.com/questions/64949572/how-to-create-status-bar-icon-and-menu-in-macos-using-swiftui
                //https://sarunw.com/posts/how-to-create-macos-app-without-storyboard/

                statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        }

        setupMenus()
    }

    func setupMenus() {


        let menu = NSMenu()


        let textMenuItem = NSMenuItem()
        textMenuItem.view = NSTextField()
        menu.addItem(textMenuItem)

        let one = NSMenuItem(title: "One", action: #selector(didTapOne), keyEquivalent: "1")
        menu.addItem(one)

        let two = NSMenuItem(title: "Two", action: #selector(didTapTwo), keyEquivalent: "2")
        menu.addItem(two)

        let three = NSMenuItem(title: "Three", action: #selector(didTapThree), keyEquivalent: "3")
        menu.addItem(three)

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        // 3
        statusItem.menu = menu

        if let window = NSApplication.shared.windows.first {
            window.close()
        }
    }


    //func menuClicked(_ sender: Any?) {
    //    let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
    //    textView.string = "This is a text view inside a popover."
    //    popover.contentViewController = NSViewController(view: textView)
    //    popover.show(relativeTo: sender!.bounds, of: sender as! NSView, preferredEdge: .maxY)
    //}

    // 1
    private func changeStatusBarButton(number: Int) {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "\(number).circle", accessibilityDescription: number.description)
        }
    }

    @objc func didTapOne() {

        // https://github.com/chojnac/NotionSwift
        //let urlsession = URLSession.new()
        let urlsession = URLSession.shared;

        let notion_secret = "secret_i2La7aDHDagTttv2j9Gzj3FQXi5TMTYEfuC889hbMAr"

        let testdbid = "4ef4fb0714c9441d94b06c826e74d5d3"
        let url2 = URL(string: "https://vanjacloudjs.azurewebsites.net/api/main/spotify")!

        let notion = NotionClient(accessKeyProvider: StringAccessKeyProvider(accessKey: notion_secret))

        let databaseId = Database.Identifier(testdbid)

        notion.databaseQuery(databaseId: databaseId) {
            print($0)
        }
        notion.database(databaseId: databaseId) {
            print($0)
        }

        let page = PageCreateRequest(
                parent: .database(databaseId),
                properties: [
                    "title": .init(
                            type: .title([
                                .init(string: "Lorem ipsum \(Date())")
                            ])
                    )
                ]
        )

        notion.pageCreate(request: page) {
            print($0)
        }

        var request = URLRequest(url: url2)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = ["name": "John Doe", "email": "johndoe@example.com"]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        do {
            let task = urlsession.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    return
                }
                print(String(data: data, encoding: .utf8)!)
            }
            task.resume()
        } catch let error {
            print(error.localizedDescription)
        }

        print("lol")
        changeStatusBarButton(number: 1)
    }

    @objc func didTapTwo() {
        changeStatusBarButton(number: 2)
    }

    @objc func didTapThree() {
        changeStatusBarButton(number: 3)
    }

    @objc func togglePopover(_ sender: Any?) {
        // Add your code here to toggle the popover
    }
}

class FFS: NSObject {
    let sourceApp: vanjacloudmacApp

    init(_ sourceApp: vanjacloudmacApp) {
        self.sourceApp = sourceApp
    }

    func load() {

        NSApplication.shared.mainMenu = nil
        let menu = NSMenu()
        let item = NSMenuItem(title: "Open Popover",
                action: #selector(menuClicked),
                //action: #selector(menuClicked),
                keyEquivalent: "")
        item.target = self
        menu.addItem(item)
        NSApplication.shared.mainMenu = menu
        sourceApp.showPopover.toggle()
    }


    @objc func menuClicked(_ sender: Any?) {
        sourceApp.showPopover.toggle()
    }
}

@main
struct vanjacloudmacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State public var showPopover: Bool = true
    @State private var mytext: String = "my text here.."
    let menuItem: NSMenuItem

//    var body: some Scene {
//            // return an empty scene
//            Scene(configuration: .init(background: Color.clear)) {
//            }
//        }
//    var body: some View {
//        EmptyView()
//    }
    var body: some Scene {
        WindowGroup {
            VStack {
                Text("Hello World")
                        .frame(width: 300, height: 300)
            }
                    .onAppear {
                        let f = FFS(self)
                        f.load()

                    }
                    .popover(isPresented: $showPopover, attachmentAnchor: .point(UnitPoint(x: 0, y: 0)), arrowEdge: .bottom) {
                        VStack {
                            TextField("Enter text here", text: $mytext)
                            Button(action: {
                                // action for the button
                            }) {
                                Text("OK")
                            }
                        }
                    }
        }
    }

    init() {
        let menu = NSMenu()
        menuItem = NSMenuItem(title: "My Menu Item", action: nil, keyEquivalent: "")
        menu.addItem(menuItem)

        //let popoverHandler = PopoverHandler(app: self, menuItem: menuItem)
        //menuItem.target = popoverHandler
        //menuItem.action = #selector(PopoverHandler.menuItemClicked)
    }


    //var body: some Scene {
    //
    //    return WindowGroup {
    //        ContentView()
    //    }
    //}
}

//let theMenu = popupMenuForValue(defaultVal: defaultValue, absMin: 1, absMax: 10)
//       NSMenu.popUpContextMenu(theMenu, with: theEvent, for: self) // returns a selected value

//@objc func setMaxi(_ sender: NSMenuItem) {
//       selectedMaxFromMenu = sender.tag
//   }
//  func popupMenuForValue(defaultVal: Int, absMin: Int, absMax: Int) -> NSMenu {
//
//           let theMenu = NSMenu(title: "Maxi") 	// Not used in fact
//           theMenu.autoenablesItems = false  // allows to deactivate some items
//           let v0 = NSAttributedString(string: NSLocalizedString("Any", comment: "popupMenuForValue"), attributes: [NSAttributedStringKey.foregroundColor:NSColor.red])
//           let item0 = NSMenuItem(title: "v0", action: #selector(setMaxi(_:)), keyEquivalent: "")
//           item0.attributedTitle = v0
//           item0.tag = 0
//           theMenu.addItem(item0)
//           let itemSeparator = NSMenuItem.separator()
//           theMenu.addItem(itemSeparator)
//
//           if absMax == 0 { return theMenu }
//           for i in 1...absMax {
//               let basicString = String(i)
//               var itemString : NSAttributedString
//               if i == defaultVal {
//                   itemString = NSAttributedString(string: basicString, attributes: 	 [NSAttributedStringKey.underlineStyle:NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.font: NSFont.boldSystemFont(ofSize: 12)])
//               } else {
//                   itemString = NSAttributedString(string: basicString, attributes: nil)
//               }
//               let item = NSMenuItem(title: String(i), action: #selector(setMaxi(_:)), keyEquivalent: "")
//               item.attributedTitle = itemString
//               item.tag = i
//               if i < absMin {
//                   item.isEnabled = false
//               }
//               theMenu.addItem(item)
//           }
//
//           return theMenu
//       }
