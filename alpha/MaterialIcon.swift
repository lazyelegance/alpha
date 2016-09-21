/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit

public struct MaterialIcon {
	/// An internal reference to the icons bundle.
	private static var internalBundle: Bundle?
	
	/**
	A public reference to the icons bundle, that aims to detect
	the correct bundle to use.
	*/
	public static var bundle: Bundle {
		if nil == MaterialIcon.internalBundle {
			MaterialIcon.internalBundle = Bundle(for: MaterialView.self)
			let b: Bundle? = Bundle(url: MaterialIcon.internalBundle!.resourceURL!.appendingPathComponent("io.cosmicmind.material.icons.bundle"))
            
			if let v: Bundle = b {
				MaterialIcon.internalBundle = v
			}
		}
		return MaterialIcon.internalBundle!
	}
	
	/// Get the icon by the file name.
    public static func icon(name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    /// Google icons.
    public static let add: UIImage? = MaterialIcon.icon(name: "ic_add_white")
	public static let addCircle: UIImage? = MaterialIcon.icon(name: "ic_add_circle_white")
	public static let addCircleOutline: UIImage? = MaterialIcon.icon(name: "ic_add_circle_outline_white")
	public static let arrowBack: UIImage? = MaterialIcon.icon(name: "ic_arrow_back_white")
    public static let arrowDownward: UIImage? = MaterialIcon.icon(name: "ic_arrow_downward_white")
    public static let audio: UIImage? = MaterialIcon.icon(name: "ic_audiotrack_white")
    public static let bell: UIImage? = MaterialIcon.icon(name: "cm_bell_white")
	public static let check: UIImage? = MaterialIcon.icon(name: "ic_check_white")
	public static let clear: UIImage? = MaterialIcon.icon(name: "ic_close_white")
    public static let close: UIImage? = MaterialIcon.icon(name: "ic_close_white")
    public static let edit: UIImage? = MaterialIcon.icon(name: "ic_edit_white")
	public static let favorite: UIImage? = MaterialIcon.icon(name: "ic_favorite_white")
	public static let favoriteBorder: UIImage? = MaterialIcon.icon(name: "ic_favorite_border_white")
	public static let history: UIImage? = MaterialIcon.icon(name: "ic_history_white")
	public static let home: UIImage? = MaterialIcon.icon(name: "ic_home_white")
	public static let image: UIImage? = MaterialIcon.icon(name: "ic_image_white")
    public static let menu: UIImage? = MaterialIcon.icon(name: "ic_menu_white")
    public static let moreHorizontal: UIImage? = MaterialIcon.icon(name: "ic_more_horiz_white")
    public static let moreVertical: UIImage? = MaterialIcon.icon(name: "ic_more_vert_white")
    public static let movie: UIImage? = MaterialIcon.icon(name: "ic_movie_white")
    public static let pen: UIImage? = MaterialIcon.icon(name: "ic_edit_white")
    public static let place: UIImage? = MaterialIcon.icon(name: "ic_place_white")
    public static let photoCamera: UIImage? = MaterialIcon.icon(name: "ic_photo_camera_white")
    public static let photoLibrary: UIImage? = MaterialIcon.icon(name: "ic_photo_library_white")
    public static let search: UIImage? = MaterialIcon.icon(name: "ic_search_white")
    public static let settings: UIImage? = MaterialIcon.icon(name: "ic_settings_white")
    public static let share: UIImage? = MaterialIcon.icon(name: "ic_share_white")
    public static let star: UIImage? = MaterialIcon.icon(name: "ic_star_white")
    public static let starBorder: UIImage? = MaterialIcon.icon(name: "ic_star_border_white")
    public static let starHalf: UIImage? = MaterialIcon.icon(name: "ic_star_half_white")
    public static let videocam: UIImage? = MaterialIcon.icon(name: "ic_videocam_white")
    public static let visibility: UIImage? = MaterialIcon.icon(name: "ic_visibility_white")
    
	/// CosmicMind icons.
    public struct cm {
        public static let add: UIImage? = MaterialIcon.icon(name: "cm_add_white")
        public static let arrowBack: UIImage? = MaterialIcon.icon(name: "cm_arrow_back_white")
		public static let arrowDownward: UIImage? = MaterialIcon.icon(name: "cm_arrow_downward_white")
		public static let audio: UIImage? = MaterialIcon.icon(name: "cm_audio_white")
		public static let audioLibrary: UIImage? = MaterialIcon.icon(name: "cm_audio_library_white")
		public static let bell: UIImage? = MaterialIcon.icon(name: "cm_bell_white")
		public static let check: UIImage? = MaterialIcon.icon(name: "cm_check_white")
		public static let clear: UIImage? = MaterialIcon.icon(name: "cm_close_white")
        public static let close: UIImage? = MaterialIcon.icon(name: "cm_close_white")
        public static let edit: UIImage? = MaterialIcon.icon(name: "cm_pen_white")
        public static let image: UIImage? = MaterialIcon.icon(name: "cm_image_white")
        public static let menu: UIImage? = MaterialIcon.icon(name: "cm_menu_white")
		public static let microphone: UIImage? = MaterialIcon.icon(name: "cm_microphone_white")
		public static let moreHorizontal: UIImage? = MaterialIcon.icon(name: "cm_more_horiz_white")
        public static let moreVertical: UIImage? = MaterialIcon.icon(name: "cm_more_vert_white")
        public static let movie: UIImage? = MaterialIcon.icon(name: "cm_movie_white")
		public static let pause: UIImage? = MaterialIcon.icon(name: "cm_pause_white")
		public static let pen: UIImage? = MaterialIcon.icon(name: "cm_pen_white")
        public static let photoCamera: UIImage? = MaterialIcon.icon(name: "cm_photo_camera_white")
		public static let photoLibrary: UIImage? = MaterialIcon.icon(name: "cm_photo_library_white")
		public static let play: UIImage? = MaterialIcon.icon(name: "cm_play_white")
		public static let search: UIImage? = MaterialIcon.icon(name: "cm_search_white")
		public static let settings: UIImage? = MaterialIcon.icon(name: "cm_settings_white")
		public static let share: UIImage? = MaterialIcon.icon(name: "cm_share_white")
		public static let shuffle: UIImage? = MaterialIcon.icon(name: "cm_shuffle_white")
		public static let skipBackward: UIImage? = MaterialIcon.icon(name: "cm_skip_backward_white")
		public static let skipForward: UIImage? = MaterialIcon.icon(name: "cm_skip_forward_white")
		public static let star: UIImage? = MaterialIcon.icon(name: "cm_star_white")
        public static let videocam: UIImage? = MaterialIcon.icon(name: "cm_videocam_white")
		public static let volumeHigh: UIImage? = MaterialIcon.icon(name: "cm_volume_high_white")
		public static let volumeMedium: UIImage? = MaterialIcon.icon(name: "cm_volume_medium_white")
		public static let volumeOff: UIImage? = MaterialIcon.icon(name: "cm_volume_off_white")
	}
}
