//
//  vanjacloudmacApp.swift
//  vanjacloudmac
//
//  Created by Vanja Oljaca on 1/31/23.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var statusItem2: NSStatusItem!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // https://gist.github.com/othyn/98f35abf988bdcfb6a118b8573d46b3b
        // https://khorbushko.github.io/article/2021/04/30/minimal-macOS-menu-bar-extra's-app-with-SwiftUI.html
        //https://stackoverflow.com/questions/64949572/how-to-create-status-bar-icon-and-menu-in-macos-using-swiftui
        //https://sarunw.com/posts/how-to-create-macos-app-without-storyboard/
        print("Colors application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
        
        
        // 2
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        // 3
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        }
        statusItem2 = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let button = statusItem2.button

        button?.image = NSImage(systemSymbolName: "2.circle", accessibilityDescription: "2")
        button?.action = #selector(togglePopover)
            
        setupMenus()
       }

       func setupMenus() {
           // 1
           let menu = NSMenu()

           // 2
           let one = NSMenuItem(title: "One", action: #selector(didTapOne) , keyEquivalent: "1")
           menu.addItem(one)

           let two = NSMenuItem(title: "Two", action: #selector(didTapTwo) , keyEquivalent: "2")
           menu.addItem(two)

           let three = NSMenuItem(title: "Three", action: #selector(didTapThree) , keyEquivalent: "3")
           menu.addItem(three)

           menu.addItem(NSMenuItem.separator())

           menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

           // 3
           statusItem.menu = menu
           
           if let window = NSApplication.shared.windows.first {
                       window.close()
                   }
       }
    
    // 1
      private func changeStatusBarButton(number: Int) {
          if let button = statusItem.button {
              button.image = NSImage(systemSymbolName: "\(number).circle", accessibilityDescription: number.description)
          }
      }

      @objc func didTapOne() {
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

@main
struct vanjacloudmacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    var body: some Scene {
//            // return an empty scene
//            Scene(configuration: .init(background: Color.clear)) {
//            }
//        }
//    var body: some View {
//        EmptyView()
//    }
    var body: some Scene {

        return WindowGroup {
            ContentView()
        }
    }
}

